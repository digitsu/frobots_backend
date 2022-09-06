defmodule FrobotsWeb.MatchChannel do
  use FrobotsWeb, :channel
  require Logger

  @type degree :: 0..359
  @type damage :: 0..100
  @type speed :: 1..100
  @type location :: {integer, integer}

  # get the name from the match registry
  defp via_tuple(name), do: {:via, Registry, {Fubars.match_registry(), name}}

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
  def join("match:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("match:" <> match_id, token, socket) do
    if authorized?(token) do
      num_clients = Map.get(socket.assigns, :listeners, 0)

      socket =
        socket
        |> assign(:listeners, num_clients + 1)
        |> assign(:match_id, String.to_integer(match_id))

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp start_cluster(socket) do
    case Fubars.Match.Supervisor.init_match(
           Integer.to_string(Map.get(socket.assigns, :match_id)),
           self()
         ) do
      {:ok, _super_name, _registry_name, _arena_name, match_name} -> {:ok, match_name}
      {:error, error} -> {:error, error}
    end
  end

  @impl true
  def handle_in("start_match", match_data, socket) do
    # create a FUBARS cluster
    # with {:ok, match_name} <- start_cluster(socket) do
    case start_cluster(socket) do
      {:ok, match_name} ->
        # now pass the match service the frobots and the match_template
        case Fubars.Match.start_match(
               via_tuple(match_name),
               match_data |> Map.get("frobots", nil) |> Frobots.Assets.load_frobots_from_db(),
               match_data
             ) do
          {:ok, frobots_map} ->
            {:reply, {:ok, frobots_map}, socket}

          {:error, error} ->
            IO.puts(error)
            Logger.error(error)
            {:reply, :error, socket}
        end

      {:error, error} ->
        IO.puts(error)
        Logger.error(error)
        {:reply, :error, socket}
    end
  end

  @impl true
  def handle_in("cancel_match", match_id, socket) do
    match_name = Fubars.Match.match_name(match_id)
    Fubars.Match.cancel_match(via_tuple(match_name))
    {:reply, :ok, socket}
  end

  @impl true
  def handle_in("request_match", _, socket) do
    match_id =
      case ConCache.get(:frobots_web, :match_count) do
        nil ->
          ConCache.put(:frobots_web, :match_count, 1)
          1

        x ->
          ConCache.put(:frobots_web, :match_count, x + 1)
          x + 1
      end

    IO.puts(~s"assigning match #{match_id}")
    {:reply, {:ok, match_id}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(payload) do
    case payload do
      nil -> false
      _ -> true
    end
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
  @spec handle_info({atom, String.t(), String.t()}, Phoenix.Socket.t()) :: tuple
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({atom, String.t(), String.t()}, Phoenix.Socket.t()) :: tuple
  def handle_info({:fsm_debug, _frobot, _fsm_state} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:scan, String.t(), degree, integer}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:scan, _frobot, _deg, _res} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:damage, String.t(), damage}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:damage, _frobot, _damage} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:create_tank, String.t(), location}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:create_tank, _frobot, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    # nop because tanks are created by the init, and we can ignore this message
    # may use this if in future init does not place the tank at loc, and only gives it a name and id.
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:move_tank, String.t(), location, degree, speed}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:move_tank, frobot, loc, heading, speed} = msg, socket) do
    inspect([:move_tank, frobot, loc, heading, speed])
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:kill_tank, String.t()}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:kill_tank, _frobot} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:create_miss, String.t(), location}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:create_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:move_miss, String.t(), location}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:move_miss, _m_name, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:kill_miss, String.t()}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:kill_miss, _m_name} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:game_over, List.t()}, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_info({:game_over, _winners} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end
end
