defmodule FrobotsWeb.Simulator do
  @moduledoc false
  use GenServer
  @vsn 1
  alias PhoenixClient.{Socket, Channel, Message}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  defp wait_for_socket(socket) do
    unless Socket.connected?(socket) do
      wait_for_socket(socket)
    end
  end

  def request_match(server) do
    GenServer.call(server, {:request_match})
  end

  def cancel_match(server) do
    GenServer.call(server, {:cancel_match})
  end

  def start_match(server, match_data) do
    # todo we need to get the match details from the client!
    GenServer.call(server, {:start_match, match_data})
  end

  defp nested_list_to_tuple(list) when is_list(list) do
    List.to_tuple(Enum.map(list, &nested_list_to_tuple/1))
  end

  defp nested_list_to_tuple(elem), do: elem

  defp decode_event(msg) do
    # msgs are in a map of shape %{"event" => evt, "args" => args}
    List.to_tuple(
      [String.to_atom(Map.get(msg, "event"))] ++
        Tuple.to_list(nested_list_to_tuple(Map.get(msg, "args")))
    )
  end

  def maybe_send_to_gui(msg) do
    # send the event message to the gui if one is registered
    ## TODO THIS
    case :global.whereis_name(Application.get_env(:frobots, :display_process_name)) do
      :undefined -> nil
      gui_pid -> send(gui_pid, msg)
    end
  end

  @impl true
  def init(_opts) do
    socket_opts = Application.get_env(:phoenix_client, :socket)
    {:ok, socket} = Socket.start_link(socket_opts)
    wait_for_socket(socket)

    {:ok, _response, lobby_channel} = Channel.join(socket, "match:lobby")

    {:ok,
     %{
       socket: socket,
       lobby_channel: lobby_channel,
       match_channel: nil,
       match_id: nil
     }}
  end

  @impl true
  def handle_call({:start_match, match_data}, _from, state) do
    case Channel.push(state.lobby_channel, "start_match", match_data) do
      {:ok, %{"frobots_map" => frobots_map, "match_id" => match_id}} ->
        {:ok, _response, match_channel} = Channel.join(state.socket, "match:#{match_id}")

        wait_for_socket(state.socket)

        {:reply, {:ok, frobots_map, match_id},
         state
         |> Map.put(:frobots_map, frobots_map)
         |> Map.put(:match_id, match_id)
         |> Map.put(:match_channel, match_channel)}

      {:error, error} ->
        {:reply, {:error, error}, state}
    end
  end

  @impl true
  def handle_call({:request_match}, _from, state) do
    {:ok, match_id} = Channel.push(state.lobby_channel, "request_match", %{})
    {:reply, {:ok, match_id}, state |> Map.put(:match_id, match_id)}
  end

  @impl true
  def handle_call({:cancel_match}, _from, state) do
    Channel.push(state.match_channel, "cancel_match", %{"id" => state.match_id})
    {:reply, :ok, state |> Map.delete(:match_id) |> Map.delete(:match_channel)}
  end

  @impl true
  def handle_info(%Message{event: "arena_event", payload: payload}, state) do
    ## WE GET THE EVENTS HEREE .......
    maybe_send_to_gui(decode_event(payload))
    {:noreply, state}
  end

  @impl true
  def handle_info(%Message{event: "phx_error", topic: _topic}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
