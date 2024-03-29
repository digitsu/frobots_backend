defmodule Frobots.MatchChannel do
  @moduledoc """
  The MatchChannel context.
  """
  use GenServer
  @vsn 1

  @name __MODULE__

  alias PhoenixClient.{Socket, Channel}
  require Logger

  def start_link(_opts) do
    Logger.info("Start Link Match Channel")
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    Logger.info("Started Match Channel")
    {:ok, %{}}
  end

  def start_match(match_id) do
    GenServer.call(@name, {:start_match, match_id})
  end

  @impl true
  def handle_call({:start_match, match_id}, _from, %{match_channel: match_channel} = state) do
    case Channel.push(match_channel, "start_match", %{"id" => match_id}) do
      {:ok, _frobots_map} ->
        {:reply, :ok, state}

      {:error, error} ->
        {:reply, {:error, error}, state}
    end
  end

  @impl true
  def handle_call({:start_match, match_id}, _from, state) do
    Logger.info("Joining Match Lobby")

    socket_opts = Application.get_env(:phoenix_client, :socket)
    {:ok, phoenix_socket} = Socket.start_link(socket_opts)
    wait_for_socket(phoenix_socket)
    {:ok, _response, match_channel} = Channel.join(phoenix_socket, "match:lobby")

    case Channel.push(match_channel, "start_match", %{"id" => match_id}) do
      {:ok, _frobots_map} ->
        {:reply, :ok, state |> Map.put(:match_channel, match_channel)}

      {:error, error} ->
        {:reply, {:error, error}, state |> Map.put(:match_channel, match_channel)}
    end
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.debug("Match Channel terminate/2 callback")
    Logger.info(reason)

    reason
  end

  defp wait_for_socket(socket) do
    unless Socket.connected?(socket) do
      wait_for_socket(socket)
    end
  end
end
