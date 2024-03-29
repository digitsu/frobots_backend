defmodule FrobotsWeb.MatchChannel do
  @moduledoc """
  This module is used to handle the match channel
  """
  use FrobotsWeb, :channel

  alias Frobots.Api
  require Logger

  @type degree :: 0..359
  @type damage :: 0..100
  @type speed :: 1..100
  @type location :: {integer, integer}

  # get the name from the match registry
  defp via_tuple(name), do: {:via, Registry, {Fubars.match_registry(), name}}

  defmodule TupleEncoder do
    @moduledoc """
    This module is used to encode tuples as lists
    """
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

  def start_cluster(match_data) when is_map(match_data) do
    case Api.create_match(match_data) do
      {:ok, match} ->
        start_cluster(match.id)

      {:error, err} ->
        {:error, "Could not start the services: " <> err}
    end
  end

  def start_cluster(match_id) when is_binary(match_id) do
    with match when not is_nil(match) <- Frobots.Api.get_match_details_by_id(match_id),
         ## validate hosts frobot
         :ok <- validate_host_frobot(match.slots),
         :ok <- validate_min_frobot(match.slots),
         {:ok, match_name} <-
           Fubars.Match.Supervisor.init_match(
             match_id,
             self()
           ) do
      {:ok, String.to_integer(match_id), match_name}
    else
      {:error, err} -> {:error, err}
    end
  end

  def start_cluster(match_id) when is_integer(match_id) do
    with match when not is_nil(match) <- Frobots.Api.get_match_details_by_id(match_id),
         ## Logics
         :ok <- validate_host_frobot(match.slots),
         :ok <- validate_min_frobot(match.slots),
         {:ok, match_name} <-
           Fubars.Match.Supervisor.init_match(
             Integer.to_string(match_id),
             self()
           ) do
      {:ok, match_id, match_name}
    else
      {:error, err} -> {:error, err}
    end
  end

  def start_match(match_id) do
    case start_cluster(match_id) do
      {:ok, match_id, match_name} ->
        # now pass the match service the frobots and the match_template
        case Fubars.Match.start_match(
               via_tuple(match_name),
               match_id
             ) do
          {:ok, frobots_map} ->
            {:ok, frobots_map}

          {:error, error} ->
            {:error, error}
        end

      {:error, error} ->
        Logger.error(error)
        {:error, error}
    end
  end

  @impl true
  def handle_in("start_match", match_data, socket) do
    # create a FUBARS cluster
    # with {:ok, match_name} <- start_cluster(socket) do
    match_data = match_data["id"] || match_data

    case start_cluster(match_data) do
      {:ok, match_id, match_name} ->
        # now pass the match service the frobots and the match_template
        case Fubars.Match.start_match(
               via_tuple(match_name),
               match_id
             ) do
          {:ok, frobots_map} ->
            {:reply, {:ok, %{"frobots_map" => frobots_map, "match_id" => match_id}}, socket}

          {:error, error} ->
            {:reply, {:error, error}, socket}
        end

      {:error, error} ->
        Logger.error(error)
        {:reply, {:error, error}, socket}
    end
  end

  @impl true
  def handle_in("cancel_match", %{"id" => match_id}, socket) do
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

    {:reply, {:ok, match_id}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(payload) do
    case payload do
      nil -> false
      _ -> true
    end
  end

  defp validate_host_frobot(slots) do
    host =
      slots
      |> Enum.count(fn s -> s.slot_type == :host end)

    if host > 0, do: :ok, else: {:error, "host frobot is required to start the match"}
  end

  defp validate_min_frobot(slots) do
    fro_pro_bot =
      slots
      |> Enum.count(fn s -> not is_nil(s.slot_type) end)

    if fro_pro_bot > 1,
      do: :ok,
      else: {:error, "minimum 2 frobots are required to start the match"}
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
  # @spec handle_info({atom, String.t(), String.t()}, Phoenix.Socket.t()) :: tuple
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  # @spec handle_info({atom, String.t(), String.t()}, Phoenix.Socket.t()) :: tuple
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
  @spec handle_info({:create_rig, String.t(), location}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:create_rig, _frobot, _loc} = msg, socket) do
    broadcast(socket, "arena_event", encode_event(msg))
    # nop because rigs are created by the init, and we can ignore this message
    # may use this if in future init does not place the rig at loc, and only gives it a name and id.
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:move_rig, String.t(), location, degree, speed}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:move_rig, frobot, loc, heading, speed} = msg, socket) do
    inspect([:move_rig, frobot, loc, heading, speed])
    broadcast(socket, "arena_event", encode_event(msg))
    {:noreply, socket}
  end

  @impl true
  @spec handle_info({:kill_rig, String.t()}, Phoenix.Socket.t()) ::
          {:noreply, Phoenix.Socket.t()}
  def handle_info({:kill_rig, _frobot} = msg, socket) do
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
