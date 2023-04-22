defmodule Frobots.Leaderboard do
  @moduledoc """
  The Leaderboard context.
  """
  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.Events
  alias Frobots.Events.Match
  alias Frobots.Assets
  alias Frobots.Leaderboard.Stats

  def create_or_update_entry(match_id) do
    # 1. given match id retrieve match. Preload battlelog
    match = Events.get_match_by([id: match_id], :battlelog)


    # now get winner and participants
    participants = match.frobots
    winners =  match.battlelog.winners
    winning_frobot = hd(winners)
    frobot = Assets.get_frobot(winning_frobot)

    matches_participated = get_match_participation_count([winning_frobot])
    matches_won = get_matches_won_count(winning_frobot)
    # start with 10 points, actual points are reduced based on how many times winning frobot fought
    # with same combination of participants
    points = compute_points(winning_frobot, participants, 10, frobot.user_id)

    stat = %{
        "points" => points,
        "xp" => frobot.xp + points,
        "attempts" => 0,
        "matches_participated" => matches_participated,
        "matches_won" => matches_won,
        "frobot_id" => frobot.id
      }

    # check if there is an entry in leaderboard_starts with winner frobot_id
    #  if yes update exisiting row
    #  else insert new row
    case get_entry(match.id) do
      nil ->
        # new entry
        create_entry(stat)
      entry ->
        # update entry
        stat = Map.delete(stat, "frobot_id")
        update_entry(entry, stat)
    end
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

  def compute_points(winner_frobot_id, participants, starting_points, user_id) do
    # we have winning frobot and participants
    q = from m in "matches",
        join: b in "battlelogs",
        on: b.match_id == m.id,
        where: m.status == "done"
                and ^winner_frobot_id in b.winners
                and m.frobots == ^participants
                and m.user_id == ^user_id,
        select: m.id

    occurences = Repo.all(q) |> Enum.count()

    points = case occurences do
      1 ->
        starting_points / 2
      2 ->
        starting_points / 2

      3 ->
        1
      _ ->
        10
    end

    round(points)
  end

  def create_entry(attrs) do
    %Stats{}
    |> Stats.changeset(attrs)
    |> Repo.insert()
  end

  def update_entry(stat, attrs) do
    # Repo.update(entry, stats)
    stat
    |> Stats.changeset(attrs)
    |> Repo.update()
  end

  def get_entry(id) do
    Repo.get(Stats, id)
  end
end
