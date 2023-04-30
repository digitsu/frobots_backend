defmodule Frobots.Leaderboard do
  @moduledoc """
  The Leaderboard context.
  """
  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.{Events, Assets}
  alias Frobots.Events.Match
  alias Frobots.Leaderboard.Stats
  alias Frobots.ChangesetError
  require Logger

  def create_or_update_entry(match_id) do
    match = Events.get_match_by([id: match_id], :battlelog)

    # now get winner and participants
    participants = match.frobots
    winners = match.battlelog.winners
    winning_frobot = hd(winners)
    frobot = Assets.get_frobot(winning_frobot)

    matches_participated = get_match_participation_count([winning_frobot])
    matches_won = get_matches_won_count(winning_frobot)

    # start with 10 points, actual points are reduced based on how many times winning frobot fought
    # with same combination of participants
    points = compute_points(winning_frobot, participants, 10)

    stat = %{
      "points" => points,
      "user_id" => match.user_id,
      "xp" => frobot.xp + points,
      "attempts" => get_match_attempts_count(winning_frobot),
      "matches_participated" => matches_participated,
      "matches_won" => matches_won,
      "frobot_id" => frobot.id
    }

    # check if there is an entry in leaderboard_starts with winner frobot_id if yes update exisiting row
    #  else insert new row
    case get_entry(winning_frobot) do
      nil ->
        # new entry
        IO.inspect("Adding new leaderboard entry")
        create_entry(stat)
        update_frobot_xp(winning_frobot, points)

      entry ->
        # update entry
        IO.inspect("Updating leaderboard entry")

        stat =
          Map.delete(stat, "frobot_id")
          |> Map.merge(%{"points" => entry.points + points})

        update_entry(entry, stat)
        update_frobot_xp(winning_frobot, points)
    end
  end

  def update_frobot_xp(frobot_id, points) do
    # find frobot
    frobot = Assets.get_frobot(frobot_id)
    new_xp = frobot.xp + points
    # get xp and add to points
    Assets.update_frobot(frobot, %{"xp" => new_xp})
  end

  # total number of matches participated
  def get_match_participation_count(frobot_id_list) do
    # https://stackoverflow.com/questions/63143363/elixir-check-array-contains-all-the-values-of-another-array
    Match
    |> where([p], p.status == :done)
    |> Repo.all()
    |> Enum.filter(fn x ->
      # check if x.frobots is a subsetof  frobot_id_list, if yes we get an empty array
      Enum.empty?(frobot_id_list -- x.frobots)
    end)
    |> Enum.count()
  end

  def get_matches_won_count(frobot_id) do
    q =
      from m in "matches",
        join: b in "battlelogs",
        on: b.match_id == m.id,
        where: m.status == "done" and ^frobot_id in b.winners,
        distinct: m.id,
        select: m.id

    Repo.all(q)
    |> Enum.count()
  end

  def get_match_attempts_count(frobot_id) do
    q =
      from m in "matches",
        join: b in "battlelogs",
        on: b.match_id == m.id,
        where: m.status in ["timeout", "cancelled"] and ^frobot_id in m.frobots,
        distinct: m.id,
        select: m.id

    Repo.all(q)
    |> Enum.count()
  end

  def compute_points(winner_frobot_id, participants, starting_points) do
    # we have winning frobot and participants
    q =
      from m in "matches",
        join: b in "battlelogs",
        on: b.match_id == m.id,
        where:
          m.status == "done" and
            ^winner_frobot_id in b.winners and
            m.frobots == ^participants,
        select: m.id

    occurences = Repo.all(q) |> Enum.count()

    points =
      case occurences do
        1 ->
          10

        2 ->
          starting_points / 2

        3 ->
          starting_points / 4

        4 ->
          1

        _ ->
          0
      end

    trunc(points)
  end

  def create_entry(attrs) do
    %Stats{}
    |> Stats.changeset(attrs)
    |> Repo.insert()
  end

  def update_entry(stat, attrs) do
    result =
      stat
      |> Stats.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, _stat} ->
        Logger.info("Updated successful")

      # Updated with success
      {:error, changeset} ->
        errors = ChangesetError.translate_errors(changeset)
        Logger.error("Updated failed", errors)
    end
  end

  def get_entry(id) do
    Repo.get_by(Stats, frobot_id: id)
  end

  def get_stats(limit \\ 50) do
    # we do not want to pull all stats in db
    q = from(s in Stats, order_by: [desc: s.points], limit: ^limit)
    Repo.all(q)
  end
end
