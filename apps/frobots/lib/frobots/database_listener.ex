defmodule Frobots.DatabaseListener do
  @moduledoc """
  The DatabaseListener context.
  """
  use GenServer
  alias Frobots.Leaderboard
  alias Frobots.Events
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
    match = Events.get_match_by([id: payload["id"]], [:battlelog])

    cond do
      is_nil(match) ->
        :ok

      not is_nil(match.tournament_id) ->
        Logger.info("update tournament score for match #{payload["id"]}")
        frobots = match.frobots
        winners = match.battlelog.winners
        update_score(frobots, match.tournament_id, winners) |> IO.inspect(label: "Update Score")

      true ->
        :ok
    end

    {:noreply, state}
  end

  # [info] update tournament score for match 458
  # [error] GenServer Frobots.DatabaseListener terminating
  # ** (ArgumentError) errors were found at the given arguments:

  #   * 1st argument: not an atom

  #   :erlang.apply(8, :id, [])
  #   (frobots 0.1.1) lib/frobots/database_listener.ex:55: anonymous fn/3 in Frobots.DatabaseListener.update_score/3
  #   (elixir 1.13.4) lib/enum.ex:937: Enum."-each/2-list

  defp update_score(frobot_ids, tournament_id, winners) do
    Enum.each(frobot_ids, fn frobot_id ->
      score = get_score(frobot_id, winners)

      tp =
        Frobots.Events.get_tournament_players_by(
          tournament_id: tournament_id,
          frobot_id: frobot_id
        )

      Frobots.Events.update_tournament_players(tp, %{score: tp.score + score})
    end)
  end

  defp get_score(frobot_id, winners) do
    cond do
      ## winnner
      length(winners) == 1 and frobot_id in winners -> 5
      ## loser
      length(winners) == 1 and frobot_id not in winners -> 1
      ## tie
      true -> 3
    end
  end
end
