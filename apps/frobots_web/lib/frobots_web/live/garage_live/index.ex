defmodule FrobotsWeb.GarageLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias FrobotsWeb.Simulator
  require Logger

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    ## Join the Match Lobby Channel
    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    {:ok, socket |> assign(:simulator, simulator)}
  end

  @impl Phoenix.LiveView
  def handle_event("request_match", _value, socket) do
    ## Request Match & Join Match ID Channel
    assigns = socket.assigns()
    {:ok, match_id} = Simulator.request_match(assigns.simulator)
    {:noreply, socket |> assign(:match_id, match_id) |> push_event(:match, %{id: match_id})}
  end

  @impl Phoenix.LiveView
  def handle_event("start_match", _match_data, socket) do
    ## Start The Match
    assigns = socket.assigns()

    ## Have to get this from FE
    match_data = %{
      commission_rate: 10,
      entry_fee: 100,
      frobots: [%{name: "sniper"}, %{name: "random"}, %{name: "rabbit"}],
      match_type: :individual,
      max_frobots: 4,
      min_frobots: 2,
      payout_map: 'd'
    }

    ## TODO :: SEND Frobots DATA so the game will be constructed based on that
    case Simulator.start_match(assigns.simulator, match_data) do
      {:ok, frobots_data} ->
        {:noreply,
         socket
         |> assign(:frobots_data, frobots_data)}

      {:error, error} ->
        Logger.error("Error in starting the match #{error}")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("cancel_match", _, socket) do
    ## Cancel the Match
    assigns = socket.assigns()
    :ok = Simulator.cancel_match(assigns.simulator)
    {:noreply, socket |> assign(:match_id, nil) |> assign(:frobots_data, %{})}
  end

  # add additional handle param events as needed to handle button clicks etc
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
end
