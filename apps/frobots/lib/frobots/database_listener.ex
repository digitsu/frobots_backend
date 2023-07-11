defmodule Frobots.DatabaseListener do
  @moduledoc """
  The DatabaseListener context.
  """
  use GenServer
  alias Frobots.Leaderboard
  require Logger
  @channel "match_status_updated"

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, [init_args], name: __MODULE__)
  end

  def init(_args) do
    repo_config = Frobots.Repo.config()

    {:ok, pid} = Postgrex.Notifications.start_link(repo_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, @channel)

    {:ok, {pid, ref}}
  end

  def handle_info({:notification, _pid, _ref, @channel, payload}, state) do
    payload = Jason.decode!(payload)
    Logger.info("Received a notification for match #{payload["id"]}")
    Leaderboard.create_or_update_entry(payload["id"])

    {:noreply, state}
  end
end
