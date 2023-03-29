defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.{Assets}
  alias FrobotsWeb.Simulator

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    frobot_id = params["id"]

    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    templates = Assets.list_template_frobots()

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
         |> assign(:frobot, frobot)}
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

    frobotDetails = %{
      "frobot_id" => frobot.id,
      "name" => frobot.name,
      "avatar" => frobot.avatar,
      "blockly_code" => frobot.blockly_code,
      "brain_code" => frobot.brain_code,
      "class" => frobot.class,
      "xp" => frobot.xp
    }

    {:noreply,
     push_event(socket, "react.return_bot_braincode", %{
       "frobot" => frobotDetails,
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
            "frobot_id" => updatedFrobot.id,
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
    player_frobot = match_data["name"]
    protobot = socket.assigns.protobot

    ## Have to get this from FE
    match_data = %{
      commission_rate: 10,
      entry_fee: 100,
      frobots: [%{name: player_frobot}, %{name: protobot}],
      match_type: :individual,
      max_frobots: 4,
      min_frobots: 2,
      payout_map: 'd'
    }

    ## TODO :: SEND Frobots DATA so the game will be constructed based on that
    case Simulator.start_match(socket.assigns.simulator, match_data) do
      {:ok, frobots_data} ->
        {:noreply,
         socket
         |> assign(:frobots_data, frobots_data)}

      {:error, error} ->
        Logger.error("Error in starting the match #{error}")
        {:noreply, socket}
    end
  end

  # @impl true
  def handle_event("cancel_match", _, socket) do
    ## Cancel the Match
    assigns = socket.assigns()
    :ok = Simulator.cancel_match(assigns.simulator)
    {:noreply, socket |> assign(:match_id, nil) |> assign(:frobots_data, %{})}
  end

  def handle_event("react.change-protobot", params, socket) do
    protobot = params

    socket =
      socket
      |> assign(:protobot, protobot)

    {:noreply, socket}
  end
end
