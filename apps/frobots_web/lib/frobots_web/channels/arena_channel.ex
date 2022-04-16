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

# -----------------------------------------------------------

  @doc """

  # This function marshals an internal elixir event of the form

    {:event_name, arg1, arg2, arg3, {arg4, arg5} ...}

  #into a map serializable over the wire of the form

    %{event: :event_name, args: [ arg1, arg2, arg3, [arg4, arg5] ... ] }

  #Which is received (after JSON encoding and decoding) as:

    %{"event" => "event_name", "args" => [ arg1, arg2, arg3, [arg4, arg5] ... ] }

  """
  defp encode_event(evt_tuple) do
    [evt | args] = Tuple.to_list(evt_tuple)
    %{event: evt, args: args}
  end

  @impl true
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:scan, _frobot, _deg, _res} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:damage, _frobot, _damage} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:create_tank, _frobot, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    # nop because tanks are created by the init, and we can ignore this message
    # may use this if in future init does not place the tank at loc, and only gives it a name and id.
    {:noreply, socket}
  end

  @impl true
  def handle_info({:move_tank, frobot, loc, heading, speed} = msg, socket) do
    inspect [:move_tank, frobot, loc, heading, speed]
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:kill_tank, _frobot} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:create_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:move_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:kill_miss, _m_name} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_over, _name} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

end
