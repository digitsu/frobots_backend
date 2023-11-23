defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.{Assets, Accounts, Events, Api}
  alias FrobotsWeb.Simulator

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    frobot_id = params["id"]

    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    templates = extract_frobot_details(Assets.list_template_frobots())

    case Assets.get_frobot(String.to_integer(frobot_id)) do
      {:error, _} ->
        {:ok,
         socket
         |> put_flash(:error, "Not found any frobot with id #{frobot_id}")
         |> push_redirect(to: "/garage")}

      {:ok, frobot} ->
        {:ok,
         socket
         |> assign(:templates, templates)
         |> assign(:simulator, simulator)
         |> assign(:frobot, frobot)
         |> assign(:user, current_user)
         |> assign(:user_snippets, Assets.list_snippet(current_user.id))
         |> assign(
           :current_user_ranking_details,
           Events.get_current_user_ranking_details(current_user)
         )}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_event("react.fetch_bot_braincode", _params, socket) do
    frobot = socket.assigns.frobot
    user = socket.assigns.user

    frobot_details = %{
      "id" => frobot.id,
      "name" => frobot.name,
      "avatar" => frobot.avatar,
      "blockly_code" => frobot.blockly_code,
      "brain_code" => frobot.brain_code,
      "class" => frobot.class,
      "xp" => frobot.xp,
      "user_id" => frobot.user_id
    }

    current_user = %{
      "active" => user.active,
      "admin" => user.admin,
      "avatar" => user.avatar,
      "email" => user.email,
      "id" => user.id,
      "name" => user.name,
      "sparks" => user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_bot_braincode", %{
       "frobot" => frobot_details,
       "currentUser" => current_user,
       "templates" => socket.assigns.templates,
       "userSnippets" => socket.assigns.user_snippets
     })}
  end

  def handle_event("react.update_bot_braincode", params, socket) do
    frobot_id = params["frobot_id"]
    brain_code = params["brain_code"]

    if brain_code === "" || is_nil(brain_code) || String.trim(brain_code) === "" do
      {:noreply, socket |> put_flash(:error, "Brain code can not be empty")}
    else
      frobot = Assets.get_frobot!(frobot_id)

      case Assets.update_frobot(frobot, params) do
        {:ok, updated_frobot} ->
          frobot_details = %{
            "id" => updated_frobot.id,
            "name" => updated_frobot.name,
            "avatar" => updated_frobot.avatar,
            "blockly_code" => updated_frobot.blockly_code,
            "brain_code" => updated_frobot.brain_code,
            "class" => updated_frobot.class,
            "xp" => updated_frobot.xp
          }

          {:noreply,
           push_event(
             socket
             |> assign(:frobot, updated_frobot)
             |> put_flash(:info, "frobot updated successfully"),
             "react.update_bot_braincode",
             %{"frobot" => frobot_details}
           )}

        {:_error, changeset} ->
          Logger.error("Error while updating brain code #{inspect(changeset)}")
          {:noreply, socket |> put_flash(:error, "Error while updating brain code")}
      end
    end
  end

  @impl Phoenix.LiveView
  def handle_event("request_match", _value, socket) do
    ## Request Match & Join Match ID Channel
    assigns = socket.assigns()
    {:ok, match_id} = Simulator.request_match(assigns.simulator)
    s3_base_url = Api.get_s3_base_url()

    {:noreply,
     socket
     |> assign(:match_id, match_id)
     |> push_event(:match, %{
       id: match_id,
       s3_base_url: s3_base_url,
       match_details: %{type: "simulation"}
     })}
  end

  # move to arena_liveview
  @impl Phoenix.LiveView
  def handle_event("start_match", match_data, socket) do
    ## Start The Match
    player_frobot_id = match_data["frobot_id"]
    protobot_ids = socket.assigns.protobot_ids

    protobot_slots =
      protobot_ids
      |> Enum.map(fn id ->
        %{
          "frobot_id" => id,
          "status" => "ready",
          "slot_type" => "protobot",
          "match_type" => "simulation"
        }
      end)

    match_data = %{
      "user_id" => socket.assigns.user.id,
      "match_time" => DateTime.utc_now() |> DateTime.to_string(),
      "timer" => 300,
      "arena_id" => 1,
      "min_player_frobot" => 2,
      "max_player_frobot" => 2,
      "type" => :simulation,
      "slots" => [
        %{
          "frobot_id" => player_frobot_id,
          "status" => "ready",
          "slot_type" => "host",
          "match_type" => "simulation"
        }
        | protobot_slots
      ],
      "frobot_ids" => [player_frobot_id] ++ protobot_ids,
      "match_template" => %{
        "entry_fee" => 0,
        "commission_rate" => 0,
        "match_type" => "individual",
        "payout_map" => [0],
        "max_frobots" => 2,
        "min_frobots" => 2
      }
    }

    case Simulator.start_match(socket.assigns.simulator, match_data) do
      {:ok, frobots_data, match_id} ->
        topic = "match:match#{match_id}"
        Logger.info("SUBSCRIBING TO #{topic}")
        Phoenix.PubSub.subscribe(Frobots.PubSub, topic)
        match = Api.get_match_details_by_id(match_id)

        {:noreply,
         socket
         |> assign(:match_id, match_id)
         |> assign(:frobots_data, frobots_data)
         |> push_event(:simulator_event, %{
           id: match_id,
           slots: extract_slot_details(match.slots)
         })}

      {:error, error} ->
        Logger.warn("Error in starting the match #{error}")
        {:noreply, socket |> put_flash(:error, error)}
    end
  end

  # @impl true
  def handle_event("cancel_match", _, socket) do
    ## Cancel the Match
    assigns = socket.assigns()
    :ok = Simulator.cancel_match(assigns.simulator)
    {:noreply, socket |> assign(:match_id, nil) |> assign(:frobots_data, %{})}
  end

  # params = %{"protobot_id" => protobot_id}
  def handle_event("react.change-protobot", %{"protobot_ids" => protobot_ids} = _params, socket) do
    socket =
      socket
      |> assign(:protobot_ids, protobot_ids)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:fsm_debug, _frobot, _fsm_state} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:scan, _frobot, _deg, _res} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:damage, _frobot, _damage} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:create_rig, _frobot, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:move_rig, _frobot, _loc, _heading, _speed} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:kill_rig, _frobot} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:create_miss, _m_name, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:move_miss, _m_name, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:kill_miss, _m_name} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:game_over, _winners} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:simulator_event, encode_event(msg))}
  end

  @impl true
  def handle_info(msg, socket) do
    Logger.info(msg)
    {:noreply, socket}
  end

  def encode_event(evt_tuple) do
    [evt | args] = Tuple.to_list(evt_tuple)
    %{event: evt, args: args}
  end

  defp extract_frobot_details(frobots) do
    Enum.map(frobots, fn %{
                           id: id,
                           name: name,
                           xp: xp,
                           class: class,
                           brain_code: brain_code,
                           blockly_code: blockly_code,
                           bio: bio,
                           avatar: avatar
                         } ->
      %{
        id: id,
        name: name,
        xp: xp,
        class: class,
        brain_code: brain_code,
        blockly_code: blockly_code,
        bio: bio,
        avatar: avatar
      }
    end)
  end

  def extract_slot_details(slots) do
    Enum.map(slots, fn %{
                         frobot: frobot,
                         frobot_id: frobot_id,
                         id: id,
                         match_id: match_id,
                         slot_type: slot_type,
                         status: status
                       } ->
      user_id =
        if frobot do
          Map.get(frobot, :user_id, nil)
        else
          nil
        end

      %{
        frobot: frobot,
        frobot_user_id: user_id,
        frobot_id: frobot_id,
        id: id,
        match_id: match_id,
        slot_type: slot_type,
        status: status
      }
    end)
  end
end
