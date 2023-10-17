defmodule Frobots.DatabaseListener do
  @moduledoc """
  The DatabaseListener context.
  """
  use GenServer
  alias Frobots.Leaderboard
  alias Frobots.{Api, Events}
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
        maybe_start_next_round(match)
      true ->
        :ok
    end

    {:noreply, state}
  end

  defp update_score(tournament_match_type, frobot_ids, tournament_id, winners) do
    Enum.each(frobot_ids, fn frobot_id ->
      score = get_score(frobot_id, winners)

      tp =
        Frobots.Events.get_tournament_players_by(
          tournament_id: tournament_id,
          frobot_id: frobot_id
        )

      if tournament_match_type == :pool do
        Frobots.Events.update_tournament_players(tp, %{pool_score: tp.pool_score + score})
      else
        Frobots.Events.update_tournament_players(tp, %{score: tp.score + score})
      end
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

  defp maybe_start_next_round(match) do
    start_after = 30 * 1000
    tournament_id = match.tournament_id
    self = String.to_atom("tournament#{tournament_id}")
    if Api.list_match_by(tournament_id: match.tournament_id) |> Enum.all?(fn m -> m.status == :done end) do
      ## Place Next Matches
      case get_match_type(tournament_id) do
        :pool ->
          Process.send_after(self, :knockout_matches, start_after)
        :knockout ->
          Process.send_after(self, :qualifier_matches, start_after)
        :qualifier ->
          Process.send_after(self, :semifinal_matches, start_after)
        :semifinal ->
          Process.send_after(self, :final_matches, start_after)
        :final -> :ok
      end
    end
  end

  defp get_match_type(tournament_id) do
    Frobots.Api.list_match_by([tournament: tournament_id], [], desc: :tournament_match_id)
    |> List.first()
    |> case do
      nil -> nil
      match -> match.tournament_match_type
    end
  end
end
