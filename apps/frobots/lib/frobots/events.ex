defmodule Frobots.Events do
  @moduledoc """
  The Assets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Frobots.Repo

  alias Frobots.Events.Battlelog
  alias Frobots.Events.{Match, Slot}
  alias Frobots.{Assets, Accounts}
  alias Frobots.Agents.WinnersBucket

  @topic inspect(__MODULE__)
  @pubsub_server Frobots.PubSub

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub_server, @topic)
  end

  defmodule FrobotLeaderboardStats do
    @derive {Jason.Encoder,
             only: [
               :frobot,
               :username,
               :points,
               :xp,
               :attempts,
               :matches_won,
               :matches_participated,
               :avatar
             ]}
    defstruct frobot: "",
              username: "",
              points: 0,
              xp: 0,
              attempts: 0,
              matches_won: 0,
              matches_participated: 0,
              avatar: ""
  end

  defp _create_battlelog(match, attrs) do
    %Battlelog{}
    |> Battlelog.changeset(parse_winners(attrs))
    |> Ecto.Changeset.put_assoc(:match, match)
    |> Ecto.Changeset.put_assoc(:frobots, parse_frobots(attrs))
  end

  def create_battlelog(%Match{} = match, attrs \\ %{}) do
    attrs = Map.put(attrs, :frobots_ids, match.frobots)

    _create_battlelog(match, attrs)
    |> Repo.insert()
  end

  def create_battlelog!(%Match{} = match, attrs \\ %{}) do
    _create_battlelog(match, attrs)
    |> Repo.insert!()
  end

  defp parse_frobots(attrs) do
    case Map.get(attrs, :frobots_ids, nil) do
      nil ->
        []

      frobots ->
        # we expect a list of frobot names
        frobots
        |> Enum.map(&get_valid_frobots/1)
        |> Enum.reject(&(&1 == nil))
    end
  end

  defp get_valid_frobots(id) when is_integer(id) do
    case Repo.get_by(Frobots.Assets.Frobot, id: id) do
      nil -> nil
      frobot -> frobot
    end
  end

  defp get_valid_frobots(name) when is_binary(name) do
    case Repo.get_by(Frobots.Assets.Frobot, name: name) do
      nil -> nil
      frobot -> frobot
    end
  end

  defp parse_winners(attrs) do
    # we expect the winners list to be a list of the names of the frobots in string
    winners =
      case Map.get(attrs, :winners, nil) do
        nil ->
          []

        winners ->
          # we expect a list of winners names, which are frobot names in the form 'sniper#n'
          # ["rabbit#1", "rook#2"]
          winners
          |> Enum.map(&get_frobot_id_from_matchname/1)
          |> Enum.reject(&(&1 == nil))
      end

    Map.put(attrs, :winners, winners)
  end

  defp get_frobot_id_from_matchname(name) do
    name
    |> String.split("#")
    |> Enum.at(0)
    |> get_valid_frobots()
    |> Map.get(:id, nil)
  end

  defp get_frobot_id_from_map(map) do
    # %{"name" => "rabbit", "type" => "proto"},
    map
    |> Map.get("name")
    |> get_valid_frobots()
    |> Map.get(:id, nil)
  end

  defp parse_frobots_to_ids(attrs) do
    frobot_ids =
      case Map.get(attrs, "frobots", nil) do
        nil ->
          []

        frobots ->
          # we expect a list of names in the attrs map,   "frobots" => [
          # %{"name" => "rabbit", "type" => "proto"},
          # %{"name" => "rook", "type" => "proto"}
          # ],
          frobots
          |> Enum.map(&get_frobot_id_from_map/1)
          |> Enum.reject(&(&1 == nil))
      end

    frobot_ids =
      case Map.get(attrs, "frobot_ids", nil) do
        nil -> frobot_ids
        ids when is_list(ids) -> ids
      end

    Map.put(attrs, "frobots", frobot_ids)
  end

  defp convert_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end

  defp _create_match(attrs) do
    attrs =
      attrs
      |> parse_frobots_to_ids()
      |> convert_map()
      |> Enum.into(%{status: :pending, match_template: Map.delete(attrs, :frobots)})

    %Match{}
    |> Match.changeset(attrs)
  end

  def create_match(attrs \\ %{}) do
    _create_match(attrs) |> Repo.insert() |> broadcast_change([:match, :created])
  end

  def change_match(%Match{} = match, attrs \\ %{}) do
    match
    |> Repo.preload([:slots, :battlelog])
    |> Match.update_changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:match, :updated])
  end

  def get_match_by(params, preload \\ []) do
    Match |> where(^params) |> preload(^preload) |> Repo.one()
  end

  def list_match_by(query, preload \\ [], order_by \\ []) do
    query |> preload(^preload) |> order_by(^order_by) |> Repo.all()
  end

  def count_matches_by_status(status) when is_atom(status) do
    count_matches_by_status(Atom.to_string(status))
  end

  def count_matches_by_status(status) do
    Repo.one(
      from m in Match,
        where: m.status == ^status and m.type == :real,
        select: count(m.id)
    )
  end

  def update_slot(%Slot{} = slot, attrs \\ %{}) do
    slot
    |> Slot.update_changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:slot, :updated])
  end

  def get_slot_by(params) do
    Repo.get_by(Slot, params)
  end

  def get_battlelog_by(params) do
    Repo.get_by(Battlelog, params)
  end

  def get_battlelogs() do
    Repo.all(Battlelog) |> Repo.preload(:frobots) |> Repo.preload(:match)
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


  # TODO: remove this....fetch leaderboard entries from leaderboard_stats
  def prep_leaderboard_entries() do
    WinnersBucket.reset()

    # 1. get battle logs
    battlelogs = get_battlelogs() |> filter_valid()
    # todo -- decide what to do if not all battlelogs can be updated
    if !Enum.empty?(battlelogs) do
      for battlelog <- battlelogs do
        # get battlelog winner..we get the user from this
        winning_frobot = battlelog.winners

        if Enum.count(winning_frobot) > 0 do
          participating_frobots = battlelog.frobots |> Enum.map(fn x -> x.id end)
          # participating_frobots = winning_frobot |> Enum.map(fn x -> x.id end)

          frobot = Assets.get_frobot(hd(winning_frobot))
          user = Accounts.get_user!(frobot.user_id)

          # participating_frobots
          if Frobots.Accounts.admin_user_name() != user.name do
            WinnersBucket.add_or_update_score(
              user.name,
              hd(winning_frobot),
              participating_frobots
            )
          end
        end
      end
    else
      # must return something to the caller. should be in {:ok, _ } or {:error, _} form.
      []
    end
  end


  # TODO: modify to read data from table instead
  def send_leaderboard_entries() do
    # fetch from agent, consolidate scores and lastly sort by points (high to low)
    WinnersBucket.value()
    |> maybe_consolidate_scores()
    |> Enum.sort_by(
      fn p ->
        p.points
      end,
      :desc
    )
    |> Enum.map_reduce({nil, 0, 0}, &do_ranking/2)
    |> elem(0)
  end


  # TODO: SRI remove this...
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

      %FrobotLeaderboardStats{
        frobot: frobot.name,
        username: current_item["username"],
        points: total_points,
        xp: frobot.xp,
        attempts: total_attempts,
        matches_won: matches_won,
        matches_participated: match_participation_count,
        avatar: frobot.avatar
      }
    end
  end


  # TODO: SRI remove this - all of this is handled inside Leaderboard module
  # referred to - https://lobste.rs/s/ionz4l/ranking_list_algorithm_elixir
  def do_ranking(%{points: points} = curr, {%{points: points}, rank, count}) do
    count = count + 1
    {Map.put(curr, :rank, rank), {curr, rank, count}}
  end

  # TODO: remove this - all of this is handled inside Leaderboard module
  def do_ranking(curr, {_, rank, count}) do
    next_rank = rank + count + 1
    {Map.put(curr, :rank, next_rank), {curr, next_rank, 0}}
  end

  # TODO: SRI remove this - all of this is handled inside Leaderboard module
  # total number of matches participated
  def get_match_participation_count(frobot_id_list) do
    # https://stackoverflow.com/questions/63143363/elixir-check-array-contains-all-the-values-of-another-array
    Match
    |> where([p], p.status == :done)
    |> Repo.all()
    |> Enum.filter(fn x ->
      # check if x.frobots is a subsetof  frobot_id_lists, if yes we get an empty array
      Enum.empty?(frobot_id_list -- x.frobots)
    end)
    |> Enum.count()
  end


  # TODO: SRI remove this - all of this is handled inside Leaderboard module
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


  #  SRI Modify this to read data from leaderboard entries
  # query data grouped by user id
  def send_player_leaderboard_entries() do
    data = send_leaderboard_entries()

    uniq_names =
      Enum.map(data, fn x -> x.username end)
      |> Enum.uniq()
      |> Enum.filter(&(!is_nil(&1)))

    # group data by username, sort and rank
    for name <- uniq_names do
      user = Accounts.get_user_by(name: name)
      avatar = user.avatar
      user_frobots = Assets.list_user_frobots(user)

      user_frobot_count = user_frobots |> Enum.count()

      total_xp =
        Enum.reduce(user_frobots, 0, fn x, acc ->
          acc + x.xp
        end)

      data
      |> Enum.filter(fn x ->
        x.username == name
      end)
      |> Enum.reduce(
        %{
          username: "",
          xp: 0,
          points: 0,
          attempts: 0,
          matches_won: 0,
          matches_participated: 0,
          avatar: ""
        },
        fn x, acc ->
          current_points = acc.points
          current_attempts = acc.attempts
          current_matches_won = acc.matches_won
          current_matches_participated = acc.matches_participated

          acc
          |> Map.put(:xp, total_xp)
          |> Map.put(:points, x.points + current_points)
          |> Map.put(:attempts, x.attempts + current_attempts)
          |> Map.put(:matches_won, x.matches_won + current_matches_won)
          |> Map.put(:matches_participated, x.matches_participated + current_matches_participated)
          |> Map.put(:frobots_count, user_frobot_count)
        end
      )
      |> Map.put(:username, name)
      |> Map.put(:avatar, avatar)
    end
    |> Enum.sort_by(
      fn p ->
        p.points
      end,
      :desc
    )
    |> Enum.map_reduce({nil, 0, 0}, &do_ranking/2)
    |> elem(0)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(@pubsub_server, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp broadcast_change(error, _event), do: error

  @doc ~S"""
  fetch current user ranking details.

  ## Example
      #iex> get_current_user_ranking_details(%User{})
      #%{username: "bob", //string
      #   points: 44, //integer
      #   xp: 100, //integer
      #   attempts: 4, //integer
      #   matches_won: 4, //integer
      #   matches_participated: 4, //integer
      #   frobots_count: 4,
      # avatar: "path/user_avatar.png"
      #}
  """
  def get_current_user_ranking_details(current_user) do
    send_player_leaderboard_entries()
    |> Enum.filter(fn x ->
      x.username == current_user.name
    end)
    |> Enum.at(0)
  end

  # get current frobot battlelogs
  def get_frobot_battlelogs(frobot_id, match_status \\ ["pending", "running"]) do
    match_status =
      Enum.flat_map(match_status, fn status ->
        case is_atom(status) do
          true -> [Atom.to_string(status)]
          false -> [status]
        end
      end)

    q =
      from m in "matches",
        join: s in "slots",
        on: m.id == s.match_id,
        join: f in "frobots",
        on: s.frobot_id == f.id,
        where: m.status in ^match_status and s.frobot_id == ^frobot_id,
        select: %{
          "match_id" => m.id,
          "match_name" => m.title,
          "winner" => "TBD",
          "xp" => f.xp,
          "status" => m.status,
          "time" => m.match_time
        }

    Repo.all(q)
  end

  def get_match_details(match_id) do
    q =
      from m in "matches",
        where: m.status == "done" and m.id == ^match_id,
        join: s in "slots",
        on: m.id == s.match_id,
        join: f in "frobots",
        on: s.frobot_id == f.id,
        join: b in "battlelogs",
        on: b.match_id == m.id,
        join: u in "users",
        on: u.id == f.user_id,
        select: %{
          "winner" => b.winners,
          "status" => m.status,
          "time" => m.match_time,
          "frobot" => %{
            "id" => f.id,
            "name" => f.name,
            "avatar" => f.avatar,
            "pixellated_image" => f.pixellated_img,
            "xp" => f.xp
          },
          "user_name" => u.name,
          "death_map" => b.death_map,
          "xp_earned" => 0
        }

    q
    |> Repo.all()
    |> Enum.map(fn e ->
      %{
        "winner" => e["winner"],
        "status" => e["status"],
        "time" => e["time"],
        "frobot" => %{
          "id" => e["frobot"]["id"],
          "name" => e["frobot"]["name"],
          "avatar" => e["frobot"]["avatar"],
          "pixellated_image" => e["frobot"]["pixellated_image"],
          "xp" => e["frobot"]["xp"]
        },
        "user_name" => e["user_name"],
        "health" => get_health(e["death_map"], e["frobot"]["name"], e["frobot"]["id"]),
        "kills" => get_kill(e["death_map"], e["frobot"]["name"], e["frobot"]["id"]),
        "xp_earned" => e["xp_earned"]
      }
    end)
  end

  defp get_health(death_map, frobot_name, frobot_id) do
    key = "#{frobot_name}##{frobot_id}"
    damage_map = Map.get(death_map, key, %{"damage_map" => %{}})["damage_map"]
    damage = Map.get(damage_map, key, 0)
    health = 100 - damage
    health
  end

  defp get_kill(death_map, frobot_name, frobot_id) do
    key = "#{frobot_name}##{frobot_id}"
    damage_map = Map.get(death_map, key, %{"damage_map" => %{}})["damage_map"]

    kills =
      Enum.reduce(damage_map, 0, fn
        {_k, 100}, count ->
          if Map.get(death_map, key, %{"killed_by" => ""})["killed_by"] == key do
            count + 1
          else
            count
          end

        _, count ->
          count
      end)

    kills
  end

  def list_paginated(query, page_config) do
    query
    |> Repo.paginate(page_config)
  end

  def list_paginated(query, page_config, preload, order_by) do
    query
    |> preload(^preload)
    |> order_by(^order_by)
    |> Repo.paginate(page_config)
  end
end
