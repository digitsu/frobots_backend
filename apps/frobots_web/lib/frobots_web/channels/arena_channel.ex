defmodule FrobotsWeb.ArenaChannel do
  use FrobotsWeb, :channel

  @match_registry Application.get_env(:fubars, :registry_name)

  @type degree :: 0..359
  @type damage :: 0..100
  @type speed :: 1..100
  @type location :: {integer, integer}

  # get the name from the match registry
  defp via_tuple(name), do: {:via, Registry, {@match_registry, name}}

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

      {:ok, sup_name, reg_name, are_name} = Fubars.MatchSupervisior.start_match(match_id)
      assign(socket, :arena, are_name)
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
  def encode_event(evt_tuple) do
    [evt | args] = Tuple.to_list(evt_tuple)
    %{event: evt, args: args}
  end

  @impl true
  @spec handle_info({atom, String.t, String.t }, Phoenix.Socket.t) :: tuple
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, degree, integer }, Phoenix.Socket.t) :: tuple
  def handle_info({:scan, _frobot, _deg, _res} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, damage }, Phoenix.Socket.t) :: tuple
  def handle_info({:damage, _frobot, _damage} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, location }, Phoenix.Socket.t) :: tuple
  def handle_info({:create_tank, _frobot, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    # nop because tanks are created by the init, and we can ignore this message
    # may use this if in future init does not place the tank at loc, and only gives it a name and id.
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, location, degree, speed }, Phoenix.Socket.t) :: tuple
  def handle_info({:move_tank, frobot, loc, heading, speed} = msg, socket) do
    inspect [:move_tank, frobot, loc, heading, speed]
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t }, Phoenix.Socket.t) :: tuple
  def handle_info({:kill_tank, _frobot} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, location }, Phoenix.Socket.t) :: tuple
  def handle_info({:create_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t, location }, Phoenix.Socket.t) :: tuple
  def handle_info({:move_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t }, Phoenix.Socket.t) :: tuple
  def handle_info({:kill_miss, _m_name} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t }, Phoenix.Socket.t) :: tuple
  def handle_info({:game_over, _winner} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

end
