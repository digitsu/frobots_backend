defmodule FrobotsWeb.ArenaChannel do
  use FrobotsWeb, :channel

  defmodule TupleEncoder do
    alias Jason.Encoder

    defimpl Encoder, for: Tuple do
      def encode(data, options) when is_tuple(data) do
        data
        |> Tuple.to_list()
        |> Encoder.List.encode(options)
      end
    end
  end

  @impl true
  def join("arena:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("arena:" <> match_id, payload, socket) do
    if authorized?(payload) do
      socket =
        socket
        |> assign(:match_id, match_id)
      {:ok, socket}
      else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("start_match", frobots, socket) do

    frobots_map = Frobots.start_match(frobots)

    {:reply, {:ok, frobots_map}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info({:fsm_state, frobot, fsm_state}, socket) do
    broadcast(socket, "arena_event", [:fsm_state, frobot, fsm_state])
    {:noreply, socket}
  end

  def handle_info({:scan, frobot, deg, res}, socket) do
    broadcast(socket, "arena_event", [:scan, frobot, deg, res])
    {:noreply, socket}
  end

  def handle_info({:damage, frobot, damage}, socket) do
    broadcast(socket, "arena_event", [:damage, frobot, damage])
    {:noreply, socket}
  end

  def handle_info({:create_tank, frobot, loc}, socket) do
    broadcast(socket, "arena_event", [:create_tank, frobot, loc])
    # nop because tanks are created by the init, and we can ignore this message
    # may use this if in future init does not place the tank at loc, and only gives it a name and id.
    {:noreply, socket}
  end

  def handle_info({:move_tank, frobot, loc, heading, speed}, socket) do
    broadcast(socket, "arena_event", [:move_tank, frobot, loc, heading, speed])
    {:noreply, socket}
  end

  def handle_info({:kill_tank, frobot}, socket) do
    broadcast(socket, "arena_event", [:kill_tank, frobot])
    {:noreply, socket}
  end

  def handle_info({:create_miss, m_name, loc}, socket) do
    broadcast(socket, "arena_event", [:create_miss, m_name, loc])
    {:noreply, socket}
  end

  def handle_info({:move_miss, m_name, loc}, socket) do
    broadcast(socket, "arena_event", [:move_miss, m_name, loc])
    {:noreply, socket}
  end

  def handle_info({:kill_miss, m_name}, socket) do
    broadcast(socket, "arena_event", [:kill_miss, m_name])
    {:noreply, socket}
  end

  def handle_info({:game_over, name}, socket) do
    broadcast(socket, "arena_event", [:game_over, name])
    {:noreply, socket}
  end

end
