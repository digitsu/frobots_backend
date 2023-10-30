defmodule Frobots.DatabaseListener do
  @moduledoc """
  The DatabaseListener context.
  """
  use GenServer
  alias Frobots.Leaderboard
  alias Frobots.Events
  alias Frobots.Tournaments
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
        update_score(match.tournament_match_type, frobots, match.tournament_id, winners)
        Tournaments.maybe_start_next_round(match.tournament_id)

      true ->
        :ok
    end

    {:noreply, state}
  end

  defp update_score(tournament_match_type, [f1, f2], tournament_id, winners) do
    tp1 =
      Frobots.Events.get_tournament_players_by(
        tournament_id: tournament_id,
        frobot_id: f1
      )

    tp2 =
      Frobots.Events.get_tournament_players_by(
        tournament_id: tournament_id,
        frobot_id: f2
      )

    score1 = get_score(f1, winners)
    score2 = get_score(f2, winners)

    # local winner
    winner = get_winner(tp1, tp2, winners)

    if tournament_match_type == :pool do
      pool_score = if is_nil(tp1.pool_score), do: 0, else: tp1.pool_score
      Frobots.Events.update_tournament_players(tp1, %{pool_score: pool_score + score1})

      pool_score = if is_nil(tp2.pool_score), do: 0, else: tp2.pool_score
      Frobots.Events.update_tournament_players(tp2, %{pool_score: pool_score + score2})
    else
      order1 = if winner == tp1, do: 1, else: 0
      old_score1 = if is_nil(tp1.score), do: 0, else: tp1.score
      Frobots.Events.update_tournament_players(tp1, %{score: old_score1 + score1, order: order1})

      order2 = if winner == tp2, do: 1, else: 0
      old_score2 = if is_nil(tp2.score), do: 0, else: tp2.score
      Frobots.Events.update_tournament_players(tp2, %{score: old_score2 + score2, order: order2})
    end
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

  defp get_winner(tp1, tp2, winners) do
    cond do
      length(winners) == 1 and tp1.frobot_id in winners -> tp1
      length(winners) == 1 and tp2.frobot_id in winners -> tp2
      tp2.score > tp1.score -> tp2
      true -> tp1
    end
  end
end
