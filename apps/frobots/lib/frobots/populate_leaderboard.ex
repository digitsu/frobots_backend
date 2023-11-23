defmodule Frobots.PopulateLeaderboard do
  @moduledoc """
  The Leaderboard context.
  """
  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.{Accounts, Assets, Leaderboard}
  alias Frobots.Events.{Match, Battlelog}
  alias Frobots.Agents.WinnersBucket
  require Logger

  # get and store data in Agent. This function must be called first and then send_leaderboard_entries
  # This function must be run manually iex.
  def prep_leaderboard_entries() do
    WinnersBucket.reset()
    # 1. get battle logs
    battlelogs = get_battlelogs() |> filter_valid()

    if Enum.empty?(battlelogs) do
      # must return something to the caller. should be in {:ok, _ } or {:error, _} form.
      []
    else
      for battlelog <- battlelogs do
        # get battlelog winner..we get the user from this
        winning_frobot = battlelog.winners

        if Enum.count(winning_frobot) > 0 do
          participating_frobots = battlelog.frobots |> Enum.map(fn x -> x.id end)
          # participating_frobots = winning_frobot |> Enum.map(fn x -> x.id end)

          case Assets.get_frobot(hd(winning_frobot)) do
            {:ok, frobot} ->
              user = Accounts.get_user!(frobot.user_id)

              # participating_frobots
              if Frobots.Accounts.admin_user_name() != user.name do
                WinnersBucket.add_or_update_score(
                  user.name,
                  hd(winning_frobot),
                  participating_frobots
                )
              end

            {:error, _} ->
              nil
          end
        end
      end
    end
  end

  def send_leaderboard_entries() do
    # clear current entries..we are going to rebuild process all entries and insert
    #  into leaderboard.
    Leaderboard.delete_all_stats()

    WinnersBucket.value()
    |> maybe_consolidate_scores()
    |> Enum.sort_by(
      fn p ->
        p.points
      end,
      :desc
    )
    |> Enum.map(fn entry ->
      # insert each entry into leaderboard_stats
      Logger.info(entry)
      Leaderboard.create_entry(entry)
    end)
  end

  # send player leaderboard entries
  @spec maybe_consolidate_scores(any) :: list
  def maybe_consolidate_scores(entries) do
    # 1. get list of unique winners. Extract frobots id from map into a list and remove dups
    unique_frobots =
      Enum.map(entries, fn x -> x["frobot_id"] end) |> Enum.to_list() |> Enum.uniq()

    # 2. for each unique forbot id , get accumulated points and attempts
    for frobot_id <- unique_frobots do
      # filter agent data based on frobot_id, we will use this data to sum the points and attempts
      filtered_data =
        WinnersBucket.value() |> Enum.filter(fn x -> x["frobot_id"] == frobot_id end)

      # get username
      current_item = Enum.at(filtered_data, 0)

      # now calculate the accumulated points and attempts
      {total_points, total_attempts} =
        Enum.reduce(filtered_data, {0, 0}, fn x, {a, b} ->
          {x["points"] + a, x["occurences"] + b}
        end)

      frobot = Frobots.Assets.get_frobot!(frobot_id)

      # match_particiaption_count = get_match_participation_count(unique_frobots)
      match_participation_count = get_match_participation_count([frobot_id])
      # get matches won by frobot
      matches_won = get_matches_won_count(frobot.id)

      %{
        frobot: frobot.name,
        frobot_id: frobot.id,
        username: current_item["username"],
        points: total_points,
        xp: frobot.xp,
        attempts: total_attempts,
        matches_won: matches_won,
        matches_participated: match_participation_count,
        avatar: frobot.avatar,
        user_id: frobot.user_id
      }
    end
  end

  defp filter_valid(battlelogs) do
    status_done? = fn status ->
      case status do
        :done -> true
        _ -> false
      end
    end

    has_valid_match? = fn bl ->
      case Map.get(bl, :match) do
        %Frobots.Events.Match{} = m -> status_done?.(m.status)
        _ -> false
      end
    end

    battlelogs |> Enum.filter(has_valid_match?)
  end

  def get_battlelogs() do
    Repo.all(Battlelog) |> Repo.preload(:frobots) |> Repo.preload(:match)
  end

  # total number of matches participated
  def get_match_participation_count(frobot_id_list) do
    # https://stackoverflow.com/questions/63143363/elixir-check-array-contains-all-the-values-of-another-array
    Match
    |> where([p], p.status == :done)
    |> Repo.all()
    |> Enum.count(fn x ->
      # check if x.frobots is a subsetof  frobot_id_lists, if yes we get an empty array
      Enum.empty?(frobot_id_list -- x.frobots)
    end)
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
end
