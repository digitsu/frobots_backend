defmodule Frobots.Events do
  @moduledoc """
  The Assets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Frobots.Repo

  alias Frobots.Events.Battlelog
  alias Frobots.Events.{Match, Slot}
  alias Frobots.Leaderboard

  @topic inspect(__MODULE__)
  @pubsub_server Frobots.PubSub

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub_server, @topic)
  end

  defmodule FrobotLeaderboardStats do
    @derive {Jason.Encoder,
             only: [
               :frobot_id,
               :frobot,
               :username,
               :points,
               :xp,
               :attempts,
               :matches_won,
               :matches_participated,
               :avatar,
               :ranking
             ]}
    defstruct frobot_id: 0,
              frobot: "",
              username: "",
              points: 0,
              xp: 0,
              attempts: 0,
              matches_won: 0,
              matches_participated: 0,
              avatar: "",
              ranking: 0
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

  def get_frobot_id_from_matchname(name) do
    name
    |> String.split("#")
    |> Enum.at(0)
    |> get_valid_frobots()
    |> Map.get(:id, nil)
  end

  def get_frobot_id_from_map(map) do
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

  def count_matches_by_status_for_user(status, user_id) when is_atom(status) do
    count_matches_by_status_for_user(Atom.to_string(status), user_id)
  end

  def count_matches_by_status_for_user(status, user_id) do
    host_matches =
      Repo.one(
        from m in Match,
          where: m.status == ^status and m.type == :real and m.user_id == ^user_id,
          select: count(m.id)
      )

    participation_matches =
      Repo.all(
        from m in Match,
          where: m.status == ^status and m.type == :real,
          join: s in "slots",
          on: m.id == s.match_id,
          join: f in "frobots",
          on: s.frobot_id == f.id,
          where: f.user_id == ^user_id and m.user_id != ^user_id,
          distinct: m.id,
          group_by: m.id,
          select: %{id: m.id}
      )
      |> length()

    if(is_nil(host_matches), do: 0, else: host_matches) + participation_matches
  end

  def list_matches_by_status_for_user(status, user_id) when is_atom(status) do
    list_matches_by_status_for_user(Atom.to_string(status), user_id)
  end

  def list_matches_by_status_for_user(status, user_id) do
    Repo.all(
      from m in Match,
        where: m.status == ^status and m.type == :real,
        join: s in "slots",
        on: m.id == s.match_id,
        join: f in "frobots",
        on: s.frobot_id == f.id,
        where: f.user_id == ^user_id,
        select: %{
          id: m.id,
          status: m.status,
          user_id: m.user_id,
          title: m.title,
          description: m.description,
          arena_id: m.arena_id
        }
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

  # defp filter_valid(battlelogs) do
  #   status_done? = fn status ->
  #     case status do
  #       :done -> true
  #       _ -> false
  #     end
  #   end

  #   has_valid_match? = fn bl ->
  #     case Map.get(bl, :match) do
  #       %Frobots.Events.Match{} = m -> status_done?.(m.status)
  #       _ -> false
  #     end
  #   end

  #   battlelogs |> Enum.filter(has_valid_match?)
  # end

  def send_leaderboard_entries() do
    Leaderboard.get_frobot_leaderboard()
  end

  # total number of matches participated
  # def get_match_participation_count(frobot_id_list) do
  #   # https://stackoverflow.com/questions/63143363/elixir-check-array-contains-all-the-values-of-another-array
  #   Match
  #   |> where([p], p.status == :done)
  #   |> Repo.all()
  #   |> Enum.filter(fn x ->
  #     # check if x.frobots is a subsetof  frobot_id_lists, if yes we get an empty array
  #     Enum.empty?(frobot_id_list -- x.frobots)
  #   end)
  #   |> Enum.count()
  # end

  # TODO: SRI remove this - all of this is handled inside Leaderboard module
  # def get_matches_won_count(frobot_id) do
  #   q =
  #     from m in "matches",
  #       join: b in "battlelogs",
  #       on: b.match_id == m.id,
  #       where: m.status == "done" and ^frobot_id in b.winners,
  #       distinct: m.id,
  #       select: m.id

  #   Repo.all(q)
  #   |> Enum.count()
  # end

  #  SRI Modify this to read data from leaderboard entries
  # query data grouped by user id
  def send_player_leaderboard_entries() do
    Leaderboard.get_player_leaderboard()
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
    Leaderboard.get_current_user_stats(current_user)

    # send_player_leaderboard_entries()
    # |> Enum.filter(fn x ->
    #   x.username == current_user.name
    # end)
    # |> Enum.at(0)
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
          "reason" => m.reason,
          "time" => m.match_time,
          "frobot" => %{
            "id" => f.id,
            "name" => f.name,
            "avatar" => f.avatar,
            "pixellated_image" => f.pixellated_img,
            "xp" => f.xp,
            "slot_id" => s.id
          },
          "user_name" => u.name,
          "death_map" => b.death_map,
          "xp_earned" => b.xp
        }

    frobots =
      q
      |> Repo.all()
      |> Enum.map(fn e ->
        %{
          "winner" => e["winner"],
          "frobot" => %{
            "id" => e["frobot"]["id"],
            "name" => e["frobot"]["name"],
            "avatar" => e["frobot"]["avatar"],
            "pixellated_image" => e["frobot"]["pixellated_image"],
            "xp" => e["frobot"]["xp"],
            "slot_id" => e["frobot"]["slot_id"]
          },
          "user_name" => e["user_name"],
          "health" => get_health(e["death_map"], e["frobot"]["name"], e["frobot"]["id"]),
          "kills" => get_kill(e["death_map"], e["frobot"]["name"], e["frobot"]["slot_id"]),
          "xp_earned" => get_xp(e["xp_earned"], e["frobot"]["id"])
        }
      end)

    m = get_match_by(id: match_id)

    %{
      "frobots" => frobots,
      "status" => get_status(m.status, m.reason),
      "time" => m.match_time
    }
  end

  defp get_status(_status, "timeout"), do: "timeout"
  defp get_status(status, _), do: status

  defp get_health(death_map, frobot_name, slot_id) do
    key = "#{frobot_name}##{slot_id}"
    damage_map = Map.get(death_map, key, %{"damage_map" => %{}})["damage_map"]
    damage = Map.get(damage_map, key, 0)
    health = 100 - damage
    health
  end

  defp get_xp(xp_earned_map, frobot_id) do
    Map.get(xp_earned_map, frobot_id |> to_string(), 0)
  end

  defp get_kill(death_map, frobot_name, frobot_id) do
    key = "#{frobot_name}##{frobot_id}"

    killers =
      Enum.reduce(death_map, [], fn {_killed, damage_map}, acc ->
        [Map.get(damage_map, "killed_by") | acc]
      end)

    Enum.count(killers, fn kills -> kills == key end)
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
