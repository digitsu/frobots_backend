defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.{Assets, Accounts, Events}
  alias FrobotsWeb.Simulator

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    frobot_id = params["id"]

    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    templates = extract_frobot_details(Assets.list_template_frobots())

    case Assets.get_frobot(String.to_integer(frobot_id)) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Not found any frobot with id #{frobot_id}")
         |> push_redirect(to: "/garage")}

      frobot ->
        {:ok,
         socket
         |> assign(:templates, templates)
         |> assign(:simulator, simulator)
         |> assign(:frobot, frobot)
         |> assign(:user, current_user)
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

    frobotDetails = %{
      "id" => frobot.id,
      "name" => frobot.name,
      "avatar" => frobot.avatar,
      "blockly_code" => frobot.blockly_code,
      "brain_code" => frobot.brain_code,
      "class" => frobot.class,
      "xp" => frobot.xp,
      "user_id" => frobot.user_id
    }

    currentUser = %{
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
       "frobot" => frobotDetails,
       "currentUser" => currentUser,
       "templates" => socket.assigns.templates
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
        {:ok, updatedFrobot} ->
          frobotDetails = %{
            "id" => updatedFrobot.id,
            "name" => updatedFrobot.name,
            "avatar" => updatedFrobot.avatar,
            "blockly_code" => updatedFrobot.blockly_code,
            "brain_code" => updatedFrobot.brain_code,
            "class" => updatedFrobot.class,
            "xp" => updatedFrobot.xp
          }

          {:noreply,
           push_event(
             socket
             |> assign(:frobot, updatedFrobot)
             |> put_flash(:info, "frobot updated successfully"),
             "react.update_bot_braincode",
             %{"frobot" => frobotDetails}
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
    {:noreply, socket |> assign(:match_id, match_id) |> push_event(:match, %{id: match_id})}
  end

  # move to arena_liveview
  @impl Phoenix.LiveView
  def handle_event("start_match", match_data, socket) do
    ## Start The Match
    player_frobot_id = match_data["frobot_id"]
    protobot_id = socket.assigns.protobot_id

    match_data = %{
      "user_id" => socket.assigns.user.id,
      "match_time" => DateTime.utc_now() |> DateTime.to_string(),
      "timer" => 30,
      "arena_id" => 1,
      "min_player_frobot" => 2,
      "max_player_frobot" => 2,
      "type" => :simulation,
      "slots" => [
        %{
          "frobot_id" => player_frobot_id,
          "status" => "ready",
          "slot_type" => "host"
        },
        %{
          "frobot_id" => protobot_id,
          "status" => "ready",
          "slot_type" => "protobot"
        }
      ],
      "frobot_ids" => [player_frobot_id, protobot_id],
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
      {:ok, frobots_data} ->
        {:noreply,
         socket
         |> assign(:frobots_data, frobots_data)}

      {:error, error} ->
        Logger.error("Error in starting the match #{error}")
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
  def handle_event("react.change-protobot", %{"protobot_id" => protobot_id} = _params, socket) do
    socket =
      socket
      |> assign(:protobot_id, protobot_id)

    {:noreply, socket}
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
end
