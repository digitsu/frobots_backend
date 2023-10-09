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
        update_score(frobots, match, winners) |> IO.inspect(label: "Update Score")

      true ->
        :ok
    end

    {:noreply, state}
  end

  defp update_score(frobots, match, winners) do
    Enum.each(frobots, fn frobot ->
      score = get_score(frobot, winners)

      tp =
        Frobots.Events.get_tournament_players_by(
          tournament_id: match.tournament_id,
          frobot_id: frobot.id
        )

      Frobots.Events.update_tournament_players(tp, %{score: tp.score + score})
    end)
  end

  defp get_score(frobot, winners) do
    cond do
      ## winnner
      frobot.id in winners and length(winners) == 1 -> 5
      ## loser
      frobot.id not in winners -> 1
      ## tie
      true -> 3
    end
  end
end
