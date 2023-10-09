defmodule Frobots.Events do
  @moduledoc """
  The Assets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Frobots.Repo

  alias Frobots.Assets
  alias Frobots.Accounts
  alias Frobots.Events.Battlelog
  alias Frobots.Events.{Match, Slot, Tournament}
  alias Frobots.Leaderboard
  alias Frobots.Events.TournamentPlayers

  @topic inspect(__MODULE__)
  @pubsub_server Frobots.PubSub

  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub_server, @topic)
  end

  defmodule FrobotLeaderboardStats do
    @moduledoc """
    The FrobotLeaderboardStats context.
    """
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
    query
    |> preload(^preload)
    |> order_by(^order_by)
    |> Repo.all()
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
    Slot |> where(^params) |> Repo.all() |> List.first()
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
            "slot_id" => s.id,
            "class" => f.class
          },
          "user_name" => u.name,
          "death_map" => b.death_map,
          "damage_map" => b.damage_map,
          "xp_earned" => b.xp
        }

    frobots = q |> Repo.all()

    winners =
      Enum.reduce(frobots, [], fn f, winner ->
        if f["frobot"]["class"] == "U" and f["frobot"]["id"] in f["winner"] do
          [f["frobot"]["id"] | winner]
        else
          winner
        end
      end)

    frobots =
      frobots
      |> Enum.map(fn e ->
        %{
          "winner" => winners,
          "frobot" => %{
            "id" => e["frobot"]["id"],
            "name" => e["frobot"]["name"],
            "avatar" => e["frobot"]["avatar"],
            "pixellated_image" => e["frobot"]["pixellated_image"],
            "xp" => e["frobot"]["xp"],
            "slot_id" => e["frobot"]["slot_id"],
            "class" => e["frobot"]["class"]
          },
          "user_name" => e["user_name"],
          "health" => get_health(e["damage_map"], e["frobot"]["name"], e["frobot"]["slot_id"]),
          "kills" => get_kill(e["death_map"], e["frobot"]["name"], e["frobot"]["slot_id"]),
          "xp_earned" => get_xp(e["xp_earned"], e["frobot"]["id"], e["frobot"]["class"])
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

  defp get_health(damage_map, frobot_name, slot_id) do
    key = "#{frobot_name}##{slot_id}"

    damage =
      if is_nil(damage_map) do
        0
      else
        Map.get(damage_map, key, 100)
      end

    if damage > 100, do: 0, else: 100 - damage
  end

  defp get_xp(xp_earned_map, frobot_id, "U") do
    Map.get(xp_earned_map, frobot_id |> to_string(), 0)
  end

  defp get_xp(_xp_earned_map, _frobot_id, _) do
    0
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

  defp _create_tournament(tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
  end

  def create_tournament(attrs \\ %{}) do
    _create_tournament(%Tournament{}, attrs)
    |> Repo.insert()
    |> case do
      {:ok, tournament} ->
        Frobots.TournamentManager.start_child(tournament.id)

        {:ok, tournament}

      error ->
        error
    end
  end

  def get_tournament_by(params, preload \\ []) do
    case Tournament |> where(^params) |> preload(^preload) |> Repo.one() do
      nil -> {:error, :not_found}
      tournament -> {:ok, tournament}
    end
  end

  def list_tournament_by(params, preload \\ []) do
    Tournament |> where(^params) |> preload(^preload) |> Repo.all()
  end

  def update_tournament(tournament, params) do
    tournament
    |> Tournament.update_changeset(params)
    |> Repo.update()
  end

  def create_tournament_players(attrs \\ %{}) do
    %TournamentPlayers{}
    |> TournamentPlayers.changeset(attrs)
    |> Repo.insert()
  end

  def update_tournament_players(tournament_player, attrs \\ %{}) do
    tournament_player
    |> TournamentPlayers.update_changeset(attrs)
    |> Repo.update()
  end

  def get_tournament_players_by(params, preload \\ []) do
    TournamentPlayers |> where(^params) |> preload(^preload) |> Repo.one()
  end

  def list_tournament_players_by(params, order_by, limit) do
    TournamentPlayers
    |> where(^params)
    |> order_by(^order_by)
    |> limit(^limit)
    |> Repo.all()
  end

  def join_tournament(tournament_id, frobot_id) do
    with {:ok, tournament} <- get_tournament_by([id: tournament_id], [:tournament_players]),
         {:is_open, true} <- {:is_open, is_open?(tournament)},
         {:is_frobot_available, true} <- {:is_frobot_available, is_frobot_available?(frobot_id)},
         frobot when not is_nil(frobot) <- Assets.get_frobot(frobot_id),
         attrs <- %{
           frobot_id: frobot_id,
           tournament_id: tournament_id,
           score: 0,
           tournament_match_type: :pool
         },
         {:ok, tp} <- create_tournament_players(attrs) do
      {:ok, tp}
    else
      {:is_open, false} -> {:error, "tournament is closed"}
      {:is_frobot_available, false} -> {:error, "frobot is already part of existing match"}
      nil -> {:error, "invalid frobot id"}
      error -> error
    end
  end

  def unjoin_tournament(tournament_id, frobot_id) do
    with {:ok, tournament} <- get_tournament_by([id: tournament_id], [:tournament_players]),
         {:is_open, true} <- {:is_open, is_open?(tournament)},
         tournament_player when not is_nil(tournament_player) <-
           Enum.find(tournament.tournament_players, fn tp -> tp.frobot_id == frobot_id end),
         {:ok, tp} <- remove_tournament_players(tournament_player) do
      {:ok, tp}
    else
      {:is_open, false} -> {:error, "tournament is closed"}
      {:is_frobot_available, false} -> {:error, "frobot is already part of existing match"}
      nil -> {:error, "frobot is not part of tournament"}
      error -> error
    end
  end

  def cancel_tournament(tournament_id, user_id) do
    with admin_user <- Accounts.get_user_by(name: Accounts.admin_user_name()),
         {:admin_check, true} <- {:admin_check, admin_user.id == user_id},
         {:ok, tournament} <- get_tournament_by([id: tournament_id], [:tournament_players]),
         {:is_open, true} <- {:is_open, is_open?(tournament)},
         {:ok, tournament} <- Frobots.Events.update_tournament(tournament, %{status: :cancelled}) do
      {:ok, tournament}
    else
      {:admin_check, false} -> {:error, "tournament can be cancelled by admin"}
      {:is_open, false} -> {:error, "tournament is in progress"}
      error -> error
    end
  end

  def player_stats(tournament_id, frobot_id) do
    with {:ok, tournament} <-
           get_tournament_by([id: tournament_id], tournament_players: [frobot: :user]),
         tp = Enum.find(tournament.tournament_players, fn tp -> tp.frobot_id == frobot_id end),
         matches =
           Frobots.Api.list_match_by(
             [tournament_match_type: :pool, tournament_id: tournament_id],
             [:battlelog]
           ),
         user_matches <- Enum.filter(matches, fn m -> frobot_id in m.frobots end) do
      wins = Enum.count(user_matches, fn m -> frobot_id in m.battlelog.winners end)
      loss = Enum.count(user_matches, fn m -> frobot_id not in m.battlelog.winners end)

      {:ok,
       %{
         frobot_name: tp.frobot.name,
         player_name: tp.frobot.user.name,
         points: tp.score,
         wins: wins,
         loss: loss
       }}
    else
      error -> error
    end
  end

  ## TODO CALL FROM JOINING A MATCH
  def is_frobot_available?(frobot_id) do
    no_matches =
      case get_slot_by(frobot_id: frobot_id, status: :ready) do
        nil -> true
        _ -> false
      end

    no_tournaments = is_frobot_part_of_tournament(frobot_id) == 0

    no_matches and no_tournaments
  end

  defp is_frobot_part_of_tournament(frobot_id) do
    q =
      from(t in "tournaments",
        join: tp in "tournament_players",
        on: tp.tournament_id == t.id,
        where: t.status in ["open", "inprogress"] and tp.frobot_id == ^frobot_id,
        select: tp.frobot_id
      )

    Repo.all(q)
    |> Enum.count()
  end

  defp is_open?(tournament) do
    tournament.status == :open and length(tournament.tournament_players) < tournament.participants
  end

  defp remove_tournament_players(tournament_player) do
    Repo.delete(tournament_player)
  end
end
