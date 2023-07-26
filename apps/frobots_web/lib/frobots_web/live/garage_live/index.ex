defmodule FrobotsWeb.GarageLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias FrobotsWeb.Simulator
  alias Frobots.{Accounts, Assets}
  require Logger
  alias Frobots.Equipment

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    ## Join the Match Lobby Channel
    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    {:ok,
     socket
     |> assign(:simulator, simulator)
     |> assign(:current_user, current_user)
     |> assign(:user_frobots, Assets.list_user_frobots(current_user))
     |> assign(:template_frobots, Assets.list_template_frobots())
     |> assign(:starter_xframes, Assets.list_xframes())
     |> assign(:starter_cannons, Assets.list_cannons())
     |> assign(:starter_scanners, Assets.list_scanners())
     |> assign(:starter_missiles, Assets.list_missiles())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # Broadcast To Client Socket
  # def handle_info(%Message{event: "arena_event", payload: payload}, state) do
  #   maybe_send_to_gui(decode_event(payload))
  #   {:noreply, state}
  # end

  defp apply_action(socket, :index, _params) do
    socket
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
  def handle_event("start_match", _match_data, socket) do
    ## Start The Match
    assigns = socket.assigns()

    ## Have to get this from FE
    match_data = %{
      commission_rate: 10,
      entry_fee: 100,
      frobots: [%{name: "sniper"}, %{name: "dummy"}, %{name: "rabbit"}],
      match_type: :individual,
      max_frobots: 4,
      min_frobots: 2,
      payout_map: 'd'
    }

    ## TODO :: SEND Frobots DATA so the game will be constructed based on that
    case Simulator.start_match(assigns.simulator, match_data) do
      {:ok, frobots_data, _match_id} ->
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

  def handle_event("create_frobot", params, socket) do
    current_user = get_user_from_assigns(socket)

    case Assets.create_frobot(current_user, params) do
      {:ok, _frobot} ->
        {:noreply,
         socket
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:error_messages, changeset.errors)}
    end
  end

  def handle_event("update_frobot", params, socket) do
    current_user = get_user_from_assigns(socket)
    frobot = Assets.get_frobot!(params["frobots_id"])

    case Assets.update_frobot(frobot, params) do
      {:ok, _frobot} ->
        {:noreply,
         socket
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:error_messages, changeset.errors)}
    end
  end

  def handle_event("create_frobot_equipment", %{"frobot_id" => _frobot_id} = params, socket) do
    current_user = get_user_from_assigns(socket)

    case Equipment.create_equipment(
           current_user,
           params["equipment_class"],
           params["equipment_type"]
         ) do
      {:ok, _frobot} ->
        {:noreply,
         socket
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:error_messages, changeset.errors)}
    end
  end

  def handle_event(
        "update_frobot_equipment",
        %{"frobot_equipment_id" => _frobot_equipment_id} = params,
        socket
      ) do
    current_user = get_user_from_assigns(socket)

    frobot_equipment =
      Equipment.get_equipment(params["equipment_class"], params["frobot_equipment_id"])

    case Equipment.update_equipment(frobot_equipment, params["equipment_class"], params) do
      {:ok, _frobot} ->
        {:noreply,
         socket
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:error_messages, changeset.errors)}
    end
  end

  def handle_event("get_frobot_details", %{"id" => frobot_id}, socket) do
    case Assets.get_frobot(frobot_id) do
      nil ->
        {:noreply,
         socket
         |> assign(:error_messages, "Unable find frobot with id #{frobot_id}")}

      frobot ->
        {:noreply,
         socket
         |> assign(:frobot, frobot)}
    end
  end

  defp get_user_from_assigns(socket) do
    assigns = socket.assigns()
    assigns["current_user"]
  end
end
