defmodule Frobots.Api do
  @moduledoc """
  The Api context.
  """
  alias Frobots.Events
  alias Frobots.Events.{Match, Slot}
  alias Frobots.Accounts.User

  alias Frobots.{Equipment, Accounts, Assets}
  alias Frobots.Events.Tournament

  # alias Frobots.Assets.{Frobot, Xframe, Missile, Scanner, Cannon}
  alias Frobots.Assets.Frobot

  alias Ecto.Multi
  alias Frobots.Repo

  require Logger
  import Ecto.Query, warn: false
  # this is the FE api for liveview pages

  def create_match(attrs) do
    match_details =
      if attrs["slots"] && is_nil(attrs["match_template"]) do
        frobot_ids =
          attrs["slots"]
          |> Enum.map(fn slot -> slot["frobot_id"] end)
          |> Enum.reject(&is_nil/1)

        attrs
        |> Map.merge(
          match_template(
            frobot_ids,
            attrs["max_player_frobot"],
            attrs["min_player_frobot"]
          )
        )
      else
        attrs
      end

    case Events.create_match(match_details) do
      {:error, cs} -> {:error, Jason.encode!(Frobots.ChangesetError.translate_errors(cs))}
      {:ok, match} -> {:ok, match}
    end
  end

  def create_tournament(attrs) do
    Events.create_tournament(attrs)
  end

  def join_tournament(attrs) do
    Events.join_tournament(attrs["tournament_id"], attrs["frobot_id"])
  end

  def unjoin_tournament(attrs) do
    Events.unjoin_tournament(attrs["tournament_id"], attrs["frobot_id"])
  end

  def cancel_tournament(attrs) do
    Events.cancel_tournament(attrs["tournament_id"], attrs["admin_user_id"])
  end

  def player_stats(attrs) do
    Events.player_stats(attrs["tournament_id"], attrs["frobot_id"])
  end

  ## params = [search_pattern: "as", tournament_status: :open | :inprogress | :completed | :cancelled]
  def list_paginated_tournaments(params \\ [], page_config \\ [], preload \\ [], order_by \\ []) do
    query = Tournament
    # |> join(:inner, [t], tp in TournamentPlayers, on: tp.tournament_id == t.id)
    # |> select([t, tp], t)

    query =
      case Keyword.get(params, :search_pattern, nil) do
        nil ->
          query

        search_pattern ->
          pattern = "%" <> search_pattern <> "%"

          query
          |> where(
            [t],
            ilike(t.name, ^pattern)
          )
      end

    query =
      case Keyword.get(params, :tournament_status, nil) do
        nil ->
          query

        tournament_status ->
          query
          |> where([t], t.status == ^tournament_status)
      end

    Events.list_paginated(query, page_config, preload, order_by)
  end

  def get_tournament_details_by_id(tournament_id),
    do:
      Events.get_tournament_by([id: tournament_id], [
        [tournament_players: [frobot: :user]],
        [matches: [:battlelog, slots: [frobot: :user]]]
      ])

  def list_tournament_matches(tournament, "pool") do
    matches =
      Enum.filter(tournament.matches, fn m ->
        m.tournament_match_type == :pool
      end)
      |> Enum.sort(fn m1, m2 -> m1.tournament_match_id < m2.tournament_match_id end)
      |> Enum.group_by(fn m ->
        m.tournament_match_sub_type
      end)

    all_keys = Map.keys(matches)

    Enum.reduce(all_keys |> Enum.sort(), [], fn key, acc ->
      match = Map.get(matches, key)

      [
        %{
          pool_name: get_pool_name(key + 96),
          pool_id: key,
          players: match |> get_players() |> get_detailed_players(tournament.id),
          matches: match
        }
        | acc
      ]
    end)
  end

  def list_tournament_matches(tournament, "knockout") do
    matches =
      Enum.filter(tournament.matches, fn m ->
        m.tournament_match_type in [:quarterfinal, :semifinal, :final]
      end)
      |> Enum.sort(fn m1, m2 -> m1.tournament_match_id < m2.tournament_match_id end)
      |> Enum.group_by(fn m ->
        m.tournament_match_type
      end)

    Enum.reduce([:final, :semifinal, :quarterfinal], [], fn key, acc ->
      match =
        case key do
          # hack to ensure only 1 final match for now, FRO-678, due to :timeouts, take the last one
          :final -> [hd(Enum.reverse(Map.get(matches, key)))]
          _ -> Map.get(matches, key)
        end

      [
        %{
          pool_name: key |> to_string() |> String.capitalize(),
          pool_id: nil,
          players: match |> get_players() |> get_detailed_players(tournament.id),
          matches: match,
          winners: match |> get_winners_for_matches()
        }
        | acc
      ]
    end)
  end

  defp get_winners_for_matches(matches) do
    Enum.map(matches, fn m -> Map.get(Map.get(m, :battlelog), :winners) end)
  end

  defp get_pool_name(value), do: <<value::utf8>> |> String.upcase()

  defp get_players(matches) do
    Enum.reduce(matches, [], fn match, acc ->
      acc ++ match.frobots
    end)
    |> Enum.uniq()
  end

  defp get_detailed_players(frobots_id, tournament_id) do
    frobots = Frobots.Assets.get_frobot_by(frobots_id, [:user])

    Enum.map(frobots, fn frobot ->
      {:ok, stats} = player_stats(%{"tournament_id" => tournament_id, "frobot_id" => frobot.id})

      %{
        name: frobot.user.name,
        id: frobot.id,
        email: frobot.user.email
      }
      |> Map.merge(stats)
    end)
  end

  # defp transform(matches) do
  #   Enum.map(matches, fn match ->
  #     Map.put(match, :battlelog, Map.get(match, :battlelog) |> Map.drop(:events))
  #   end)
  # end

  ## params = [search_pattern: "as", match_status: :done, match_type: :real]
  def list_paginated_matches(params \\ [], page_config \\ [], preload \\ [], order_by \\ []) do
    query =
      Match
      |> join(:left, [match], u in User, on: match.user_id == u.id)

    query =
      case Keyword.get(params, :search_pattern, nil) do
        nil ->
          query

        search_pattern ->
          pattern = "%" <> search_pattern <> "%"

          query
          |> where(
            [match, user],
            ilike(user.name, ^pattern) or ilike(match.title, ^pattern) or
              fragment("CAST( ? AS TEXT) LIKE ?", match.id, ^pattern)
          )
      end

    query =
      case Keyword.get(params, :match_status, nil) do
        nil ->
          query

        match_status ->
          query
          |> where([match, user], match.status == ^match_status)
      end

    query =
      case Keyword.get(params, :match_type, nil) do
        nil ->
          query
          |> where([match, user], match.type == :real)

        match_type ->
          query
          |> where([match, user], match.type == ^match_type)
      end

    Events.list_paginated(query, page_config, preload, order_by)
  end

  ## params = [frobot_id: 1, match_status: [:done]]
  def list_paginated_frobot_battlelog(params \\ [], page_config \\ []) do
    query =
      Match
      |> join(:left, [m], s in Slot, on: m.id == s.match_id)
      |> join(:left, [m, s], f in Frobot, on: s.frobot_id == f.id)

    match_status = Keyword.get(params, :match_status, ["pending", "running"])

    query =
      if is_list(match_status) do
        query
        |> where([m, s, f], m.status in ^match_status)
      else
        query
        |> where([m, s, f], m.status == ^match_status)
      end

    query =
      case Keyword.get(params, :frobot_id, nil) do
        nil ->
          query

        frobot_id ->
          query
          |> where([m, s, f], f.id == ^frobot_id)
      end

    query =
      query
      |> select([m, s, f], %{
        "match_id" => m.id,
        "match_name" => m.title,
        "winner" => "TBD",
        "xp" => f.xp,
        "status" => m.status,
        "time" => m.match_time
      })

    Events.list_paginated(query, page_config)
  end

  def count_matches_by_status(status), do: Events.count_matches_by_status(status)

  def count_matches_by_status_for_user(status, user_id),
    do: Events.count_matches_by_status_for_user(status, user_id)

  def get_match_details_by_id(match_id),
    do: Events.get_match_by([id: match_id], slots: [frobot: :user])

  def list_match_by(params, preload \\ [], order_by \\ []) do
    query = Match

    query =
      case Keyword.get(params, :match_status, nil) do
        nil ->
          query

        match_status ->
          query
          |> where([match], match.status == ^match_status)
      end

    query =
      case Keyword.get(params, :match_type, nil) do
        nil ->
          query
          |> where([match], match.type == :real)

        match_type ->
          query
          |> where([match], match.type == ^match_type)
      end

    query =
      case Keyword.get(params, :match_time, nil) do
        nil ->
          query

        match_time ->
          query
          |> where([match], match.match_time <= ^match_time)
      end

    query =
      case Keyword.get(params, :tournament_match_type, nil) do
        nil ->
          query

        tournament_match_type ->
          query
          |> where([match], match.tournament_match_type == ^tournament_match_type)
      end

    query =
      case Keyword.get(params, :tournament_id, nil) do
        nil ->
          query

        tournament_id ->
          query
          |> where([match], match.tournament_id == ^tournament_id)
      end

    Events.list_match_by(query, preload, order_by)
  end

  def list_matches_by_status_for_user(status, user_id),
    do:
      Events.list_matches_by_status_for_user(status, user_id)
      |> Enum.group_by(fn match -> match_type(match.user_id, user_id) end)

  def get_replay_events(match_id) do
    case Events.get_battlelog_by(match_id: match_id) do
      nil ->
        {:error, :not_found}

      battlelog ->
        if is_nil(battlelog.events) or is_nil(Map.get(battlelog.events, "match:match#{match_id}")) do
          {:error, :not_found}
        else
          {:ok, Map.get(battlelog.events, "match:match#{match_id}")}
        end
    end
  end

  defp match_type(user_id, user_id), do: "host"
  defp match_type(_, _), do: "joined"

  def update_slot(match, user_id, slot_id, attrs) do
    validation_check? = if attrs.slot_type == :protobot, do: match.user_id == user_id, else: true

    if validation_check? do
      case Events.get_slot_by(id: slot_id, match_id: match.id) do
        nil -> {:error, :slot_not_found}
        %Slot{} = slot -> Events.update_slot(slot, attrs)
      end
    else
      {:error, :invalid_protobot}
    end
  end

  def create_frobot(user, name, brain_code, extra_params \\ %{})

  def create_frobot(user, _name, _brain_code, _extra_params) when user.sparks <= 0 do
    {:error, "User does not have enough sparks."}
  end

  def create_frobot(_user, name, brain_code, _extra_params)
      when name == "" or brain_code == "" do
    Logger.debug("Name and Braincode required to create frobot")
    {:error, "Frobot name and braincode are required."}
  end

  @doc ~S"""
    Create Frobot
    We pass name and brain code so that we pattern match on required fieldsby checking guard functions

    Here is an example of how to create a frobot and associated equipmet instances
    #iex>alias Frobots.{Accounts, Assets,Equipment,Api}
    #iex>usr = %{"email" => "sriram@mail.com", "password" => "Password123", "sparks" => 6}
    #iex>{:ok, user} = Accounts.register_user(usr)

    #iex>extra_params=%{"bio" => "bio", "blobkly_code" => "boo"}
    #iex>Api.create_frobot(user, "bulbul" ,"sniper",extra_params)
  """
  def create_frobot(user, name, brain_code, extra_params) do
    # _default_loadout = Frobots.default_frobot_loadout()
    # extra_params may contain bio, pixellated_img, avatar, blockly_code
    frobot_attrs =
      Map.merge(extra_params, %{
        "name" => name,
        "brain_code" => brain_code,
        "class" => Assets.default_user_class()
      })

    case _frobot_insert_multi(user, frobot_attrs) |> _run_multi() do
      {:ok, res} -> {:ok, res.frobot.id}
      {:error, msg} -> msg
    end
  end

  @doc ~S"""
  This function is to reset (or set) frobot with default setup and equipment
  """
  def reset_frobot(frobot) do
    frobot = frobot |> Repo.preload(:user)
    Equipment.dequip_all(frobot)

    case _frobot_update_multi(frobot.user, frobot) |> _run_multi() do
      {:ok, res} -> res
      {:error, msg} -> msg
    end
  end

  @doc ~S"""

    This is called internally called from create_frobot to build an Ecto.multi structure.
    Building Ecto.multi structure in separate function makes testing easier.

    ex: multi_list = Api._frobot_insert_multi(user, @valid_frobot_attrs) |> Ecto.Multi.to_list()

    Where multi_list is a list of changesets that can asserted for validity.

  """
  def _frobot_insert_multi(user, frobot_attrs) do
    Multi.new()
    |> Multi.insert(:frobot, create_frobot_changeset(user, frobot_attrs))
    |> Multi.insert(
      :xframe_inst,
      Equipment.create_equipment_changeset(user, "Xframe", :Chassis_Mk1)
    )
    |> Multi.insert(:cannon_inst, Equipment.create_equipment_changeset(user, "Cannon", :Mk1))
    |> Multi.insert(:scanner_inst, Equipment.create_equipment_changeset(user, "Scanner", :Mk1))
    |> Multi.insert(:missile_inst, Equipment.create_equipment_changeset(user, "Missile", :Mk1))
    |> Multi.insert(:cpu_inst, Equipment.create_equipment_changeset(user, "Cpu", :Mk1))
    |> Multi.insert(
      :xframe_inst_mk2,
      Equipment.create_equipment_changeset(user, "Xframe", :Chassis_Mk2)
    )
    |> Multi.insert(:cannon_inst_mk2, Equipment.create_equipment_changeset(user, "Cannon", :Mk2))
    |> Multi.insert(
      :scanner_inst_mk2,
      Equipment.create_equipment_changeset(user, "Scanner", :Mk2)
    )
    |> Multi.insert(
      :missile_inst_mk2,
      Equipment.create_equipment_changeset(user, "Missile", :Mk2)
    )
    |> Multi.insert(
      :xframe_inst_mk3,
      Equipment.create_equipment_changeset(user, "Xframe", :Chassis_Mk3)
    )
    |> Multi.insert(:cannon_inst_mk3, Equipment.create_equipment_changeset(user, "Cannon", :Mk3))
    |> Multi.insert(
      :scanner_inst_mk3,
      Equipment.create_equipment_changeset(user, "Scanner", :Mk3)
    )
    |> Multi.update(:equip_xframe, fn %{frobot: frobot, xframe_inst: xframe_inst} ->
      Equipment.equip_xframe_changeset(xframe_inst.id, frobot.id)
    end)
    |> Multi.update(:equip_cannon, fn %{frobot: frobot, cannon_inst: cannon_inst} ->
      Equipment.equip_part_changeset(cannon_inst.id, frobot.id, "Cannon")
    end)
    |> Multi.update(:equip_scanner, fn %{frobot: frobot, scanner_inst: scanner_inst} ->
      Equipment.equip_part_changeset(scanner_inst.id, frobot.id, "Scanner")
    end)
    |> Multi.update(:equip_cpu, fn %{frobot: frobot, cpu_inst: cpu_inst} ->
      Equipment.equip_cpu_changeset(cpu_inst.id, frobot.id)
    end)
    # |> Multi.update(:equip_missile, fn %{frobot: frobot, missile_inst: missile_inst} ->
    #   Equipment.equip_part_changeset(missile_inst.id, frobot.id, "Missile")
    # end)
    |> Multi.update(:update_user, fn %{frobot: frobot} ->
      decr_sparks_changeset(frobot.user_id)
    end)
  end

  def _frobot_update_multi(user, frobot) do
    Multi.new()
    |> Multi.insert(
      :xframe_inst,
      Equipment.create_equipment_changeset(user, "Xframe", :Chassis_Mk1)
    )
    |> Multi.insert(:cannon_inst, Equipment.create_equipment_changeset(user, "Cannon", :Mk1))
    |> Multi.insert(:scanner_inst, Equipment.create_equipment_changeset(user, "Scanner", :Mk1))
    |> Multi.insert(:missile_inst, Equipment.create_equipment_changeset(user, "Missile", :Mk1))
    |> Multi.insert(:cpu_inst, Equipment.create_equipment_changeset(user, "Cpu", :Mk1))
    |> Multi.update(:equip_xframe, fn %{xframe_inst: xframe_inst} ->
      Equipment.equip_xframe_changeset(xframe_inst.id, frobot.id)
    end)
    |> Multi.update(:equip_cannon, fn %{cannon_inst: cannon_inst} ->
      Equipment.equip_part_changeset(cannon_inst.id, frobot.id, "Cannon")
    end)
    |> Multi.update(:equip_scanner, fn %{scanner_inst: scanner_inst} ->
      Equipment.equip_part_changeset(scanner_inst.id, frobot.id, "Scanner")
    end)
    |> Multi.update(:equip_cpu, fn %{frobot: frobot, cpu_inst: cpu_inst} ->
      Equipment.equip_cpu_changeset(cpu_inst.id, frobot.id)
    end)

    #  |> Multi.update(:equip_missile, fn %{missile_inst: missile_inst} ->
    #    Equipment.equip_part_changeset(missile_inst.id, frobot.id, "Missile")
    #  end)
  end

  @doc ~S"""
    Runs Multi structure
    This function is called after _frobot_insert_multi.

    The actual db operations are run in this step as a transaction and any failures are rolled back
    Function returns {:ok, frobot_id} or {:error, reason} to caller
  """
  def _run_multi(multi) do
    case Repo.transaction(multi) do
      {:ok, res} ->
        {:ok, res}

      {:error, :frobot, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :xframe_inst, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :cannon_inst, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :scanner_inst, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :missile_inst, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :cpu_inst, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :equip_xframe, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :equip_cannon, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :equip_scanner, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :equip_cpu, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)

      {:error, :update_user, %Ecto.Changeset{} = cs, changes} ->
        Logger.info(changes)
        return_errors(cs)
    end
  end

  defp return_errors(%Ecto.Changeset{} = cs) do
    errors = changeset_error_to_string(cs)
    {:error, errors}
  end

  defp create_frobot_changeset(user, attrs) do
    %Frobot{}
    |> Frobot.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
  end

  @doc ~S"""
    Given frobot name or id, fetches frobot details along with equipment instances
    Usage
    #iex> {:ok, frobot} = Api.get_frobot_details("piper")

    #iex>{:error, "There are no frobots with given name"} = Api.get_frobot_details("unknown")

    Successful response looks like this
    ```
     %{
      "avatar" => "https://via.placeholder.com/50.png"",
      "bio" => "bio",
      "brain_code" => "sniper",
      "cannon_inst" => [
        %{
          "cannon_id" => 1,
          "id" => 1,
          "image" => "https://via.placeholder.com/50.png",
          "magazine_size" => 2,
          "rate_of_fire" => 1,
          "reload_time" => 5,
          "equipment_class" => "cannon",
          "equipment_type" => :Mk1
        },
        %{
          "cannon_id" => 2,
          "id" => 2,
          "image" => "https://via.placeholder.com/50.png",
          "magazine_size" => 2,
          "rate_of_fire" => 1,
          "reload_time" => 5,
          "equipment_class" => "cannon",
          "equipment_type" => :Mk2
        }
      ],
      "frobot_id" => 8,
      "missile_inst" => [
        %{
          "damage_direct" => [5, 10],
          "damage_far" => [40, 3],
          "damage_near" => [20, 5],
          "id" => 1,
          "image" => "https://via.placeholder.com/50.png",
          "missile_id" => 1,
          "range" => 900,
          "speed" => 400,
          "equipment_class" => "missile",
          "equipment_type" => :Mk1
        }
      ],
      "name" => "piper",
      "pixellated_img" => "https://via.placeholder.com/50.png",
      "scanner_inst" => [
        %{
          "id" => 1,
          "image" => "https://via.placeholder.com/50.png",
          "max_range" => 700,
          "resolution" => 10,
          "scanner_id" => 1,
          "equipment_class" => "scanner",
          "equipment_type" => :Mk1,
        }
      ],
      "user_id" => 2,
      "xframe_inst" => [
        %{
          "accel_speed_mss" => 5,
          "health" => nil,
          "id" => 1,
          "image" => "https://via.placeholder.com/50.png",
          "max_health" => 100,
          "max_speed_ms" => 30,
          "max_throttle" => 100,
          "turn_speed" => 50,
          "equipment_class" => "xframe",
          "equipment_type" => :Chassis_Mk1,
          "xframe_id" => 1
        }
      ],
      "xp" => 0
     }
    ```

  """
  def get_frobot_details(id_or_name) do
    case Assets.get_frobot(id_or_name) do
      {:error, :not_found} ->
        {:error, "There are no frobots with given id/name"}

      {:ok, frobot} ->
        _preload_equipment_instances(frobot)
    end
  end

  @doc ~S"""
    Returns the base url to use to fetch images from s3.
    Use this base url to fetch images from the appropriate bucket.

    Example
    #iex>Api.get_image_base_url()
    #iex> {:ok, "https://ap-south-1.linodeobjects.com/frobots-assets"}
  """
  def get_s3_base_url() do
    s3_base_url = Application.get_env(:ex_aws, :s3)[:host]
    s3_bucket = Application.get_env(:ex_aws, :s3)[:bucket]

    "https://#{s3_base_url}/#{s3_bucket}/"
  end

  def get_battle_background_audio() do
    Application.get_env(:frobots_web, :battle_background)
  end

  def get_s3_bucket_name() do
    Application.get_env(:ex_aws, :s3)[:bucket]
  end

  def _preload_equipment_instances(frobot) do
    frobot
    |> Repo.preload(xframe_inst: [:xframe])
    |> Repo.preload(cannon_inst: [:cannon])
    |> Repo.preload(scanner_inst: [:scanner])
    |> Repo.preload(missile_inst: [:missile])
    |> Repo.preload(cpu_inst: [:cpu])
    |> _parse_frobot_details()
  end

  defp _parse_frobot_details(frobot) do
    frobot_details = %{
      "frobot_id" => frobot.id,
      "name" => frobot.name,
      "brain_code" => frobot.brain_code,
      "pixellated_img" => frobot.pixellated_img,
      "avatar" => frobot.avatar,
      "xp" => frobot.xp,
      "bio" => frobot.bio,
      "user_id" => frobot.user_id,
      "class" => frobot.class
    }

    frobot_details =
      if frobot.class in [Assets.prototype_class(), Assets.target_class()] do
        frobot_details
      else
        xframe_inst = _get_xframe_inst_details(frobot)
        cannon_inst = _get_cannon_inst_details(frobot)
        scanner_inst = _get_scanner_inst_details(frobot)
        missile_inst = _get_missile_inst_details(frobot)
        cpu_inst = _get_cpu_inst_details(frobot)

        Map.put(frobot_details, "xframe_inst", xframe_inst)
        |> Map.put("cannon_inst", cannon_inst)
        |> Map.put("scanner_inst", scanner_inst)
        |> Map.put("missile_inst", missile_inst)
        |> Map.put("cpu_inst", cpu_inst)
      end

    {:ok, frobot_details}
  end

  defp _get_xframe_inst_details(frobot) do
    if Map.has_key?(frobot, :xframe_inst) do
      xframe_inst = Map.get(frobot, :xframe_inst)

      if is_nil(xframe_inst) do
        []
      else
        [
          %{
            "id" => Map.get(xframe_inst, :id),
            "xframe_id" => Map.get(xframe_inst, :xframe_id),
            "max_speed_ms" => Map.get(xframe_inst, :max_speed_ms),
            "turn_speed" => Map.get(xframe_inst, :turn_speed),
            "max_health" => Map.get(xframe_inst, :max_health),
            "health" => Map.get(xframe_inst, :health),
            "max_throttle" => Map.get(xframe_inst, :max_throttle),
            "accel_speed_mss" => Map.get(xframe_inst, :accel_speed_mss),
            "image" => frobot.xframe_inst.xframe.image,
            "equipment_class" => frobot.xframe_inst.xframe.class,
            "equipment_type" => frobot.xframe_inst.xframe.type
          }
        ]
      end
    else
      []
    end
  end

  defp _get_cannon_inst_details(frobot) do
    if Map.has_key?(frobot, :cannon_inst) do
      cannon_inst_list = Map.get(frobot, :cannon_inst)

      if Enum.empty?(cannon_inst_list) do
        []
      else
        Enum.map(cannon_inst_list, fn cannon_inst ->
          %{
            "id" => cannon_inst.id,
            "cannon_id" => cannon_inst.cannon_id,
            "reload_time" => cannon_inst.reload_time,
            "rate_of_fire" => cannon_inst.rate_of_fire,
            "magazine_size" => cannon_inst.magazine_size,
            "image" => cannon_inst.cannon.image,
            "equipment_class" => cannon_inst.cannon.class,
            "equipment_type" => cannon_inst.cannon.type
          }
        end)
      end
    else
      []
    end
  end

  defp _get_scanner_inst_details(frobot) do
    if Map.has_key?(frobot, :scanner_inst) do
      scanner_inst_list = Map.get(frobot, :scanner_inst)

      if Enum.empty?(scanner_inst_list) do
        []
      else
        Enum.map(scanner_inst_list, fn scanner_inst ->
          %{
            "id" => scanner_inst.id,
            "scanner_id" => scanner_inst.scanner_id,
            "max_range" => scanner_inst.max_range,
            "resolution" => scanner_inst.resolution,
            "image" => scanner_inst.scanner.image,
            "equipment_class" => scanner_inst.scanner.class,
            "equipment_type" => scanner_inst.scanner.type
          }
        end)
      end
    else
      []
    end
  end

  defp _get_missile_inst_details(frobot) do
    if Map.has_key?(frobot, :missile_inst) do
      missile_inst_list = Map.get(frobot, :missile_inst)

      if Enum.empty?(missile_inst_list) do
        []
      else
        Enum.map(missile_inst_list, fn missile_inst ->
          %{
            "id" => missile_inst.id,
            "missile_id" => missile_inst.missile_id,
            "damage_direct" => missile_inst.damage_direct,
            "damage_near" => missile_inst.damage_near,
            "damage_far" => missile_inst.damage_far,
            "speed" => missile_inst.speed,
            "range" => missile_inst.range,
            "image" => missile_inst.missile.image,
            "equipment_class" => missile_inst.missile.class,
            "equipment_type" => missile_inst.missile.type
          }
        end)
      end
    else
      []
    end
  end

  defp _get_cpu_inst_details(frobot) do
    if Map.has_key?(frobot, :cpu_inst) do
      cpu_inst = Map.get(frobot, :cpu_inst)

      if is_nil(cpu_inst) do
        []
      else
        [
          %{
            "id" => cpu_inst.id,
            "type" => cpu_inst.cpu.type,
            "cycletime" => cpu_inst.cycletime,
            "cpu_cycle_buffer" => cpu_inst.cpu_cycle_buffer,
            "overload_penalty" => cpu_inst.overload_penalty
          }
        ]
      end
    else
      []
    end
  end

  # todo this is wrong to always decrement the sparks.
  defp decr_sparks_changeset(user_id) do
    user = Accounts.get_user_by(id: user_id)
    attrs = %{"sparks" => user.sparks - 1}

    user
    |> User.profile_changeset(attrs)
  end

  defp match_template(frobot_ids, max_frobots, min_frobots) do
    %{
      "frobot_ids" => frobot_ids,
      "match_template" => %{
        "entry_fee" => 0,
        "commission_rate" => 0,
        "match_type" => "individual",
        "payout_map" => [100],
        "max_frobots" => max_frobots,
        "min_frobots" => min_frobots
      }
    }
  end

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

  def list_arena() do
    [
      %{
        id: 1,
        image_url: "images/arenas/arena1.png",
        arena_name: "Bloodbath Basin",
        arena_description:
          "A shallow, rocky basin filled with blood-red water that hides deadly surprises."
      },
      %{
        id: 2,
        image_url: "images/arenas/arena2.png",
        arena_name: "Kraken's Keep",
        arena_description:
          "A fortress perched on the edge of a massive ocean trench where opponents battle."
      },
      %{
        id: 3,
        image_url: "images/arenas/arena3.png",
        arena_name: "Phantom Palace",
        arena_description:
          "A grand palace filled with eerie illusions and ghostly apparitions that haunt opponents."
      },
      %{
        id: 4,
        image_url: "images/arenas/arena4.png",
        arena_name: "Midnight Mirage",
        arena_description:
          "A dark and mysterious arena where opponents must navigate treacherous terrain and illusions."
      }
    ]
  end

  def get_default_xframe!(), do: Assets.get_xframe!(:Chassis_Mk1)
  def get_default_cpu!(), do: Assets.get_cpu!(:Mk1)

  def get_default_cannon!(), do: Assets.get_cannon!(:Mk1)
  def get_default_missile!(), do: Assets.get_missile!(:Mk1)
  def get_default_scanner!(), do: Assets.get_scanner!(:Mk1)
end
