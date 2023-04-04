defmodule Frobots.Api do
  alias Frobots.Events
  alias Frobots.Events.{Match, Slot}
  alias Frobots.Accounts.User

  alias Frobots.{Equipment, Accounts, Assets}

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

    Events.create_match(match_details)
  end

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
          |> where([match], match.type == :real)

        match_type ->
          query
          |> where([match], match.type == ^match_type)
      end

    Events.list_paginated_matches(query, page_config, preload, order_by)
  end

  def count_matches_by_status(status), do: Events.count_matches_by_status(status)

  def get_match_details_by_id(match_id),
    do: Events.list_match_by([id: match_id], slots: [frobot: :user]) |> List.first()

  def update_slot(match_id, slot_id, attrs) do
    case Events.get_slot_by(id: slot_id, match_id: match_id) do
      nil -> {:error, :slot_not_found}
      %Slot{} = slot -> Events.update_slot(slot, attrs)
    end
  end

  def join_match(_user, _match) do
  end

  def create_frobot(user, _name, _brain_code, _extra_params) when user.sparks <= 0 do
    {:error, "User does not have enough sparks."}
  end

  def create_frobot(_user, name, brain_code, _extra_params)
      when name == "" or
             brain_code == "" do
    IO.inspect("Name and Braincode required to create frobot")
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

    _create_frobot_build_multi(user, frobot_attrs)
    |> _create_frobot_run_multi()
  end

  @doc ~S"""

    This is called internally called from create_frobot to build an Ecto.multi structure.
    Building Ecto.multi structure in separate function makes testing easier.

    ex: multi_list = Api._create_frobot_build_multi(user, @valid_frobot_attrs) |> Ecto.Multi.to_list()

    Where multi_list is a list of changesets that can asserted for validity.

  """
  def _create_frobot_build_multi(user, frobot_attrs) do
    Multi.new()
    |> Multi.insert(:frobot, create_frobot_changeset(user, frobot_attrs))
    |> Multi.insert(
      :xframe_inst,
      Equipment.create_equipment_changeset(user, "Xframe", :Chassis_Mk1)
    )
    |> Multi.insert(:cannon_inst, Equipment.create_equipment_changeset(user, "Cannon", :Mk1))
    |> Multi.insert(:scanner_inst, Equipment.create_equipment_changeset(user, "Scanner", :Mk1))
    |> Multi.insert(:missile_inst, Equipment.create_equipment_changeset(user, "Missile", :Mk1))
    |> Multi.update(:equip_xframe, fn %{frobot: frobot, xframe_inst: xframe_inst} ->
      Equipment.equip_xframe_changeset(xframe_inst.id, frobot.id)
    end)
    |> Multi.update(:equip_cannon, fn %{frobot: frobot, cannon_inst: cannon_inst} ->
      Equipment.equip_part_changeset(cannon_inst.id, frobot.id, "Cannon")
    end)
    |> Multi.update(:equip_scanner, fn %{frobot: frobot, scanner_inst: scanner_inst} ->
      Equipment.equip_part_changeset(scanner_inst.id, frobot.id, "Scanner")
    end)
    |> Multi.update(:update_user, fn %{frobot: frobot} ->
      update_user_changeset(frobot.user_id)
    end)
  end

  @doc ~S"""
    Runs Multi structure
    This function is called after _create_frobot_build_multi.

    The actual db operations are run in this step as a transaction and any failures are rolled back
    Function returns {:ok, frobot_id} or {:error, reason} to caller
  """
  def _create_frobot_run_multi(multi) do
    case Repo.transaction(multi) do
      {:ok, result} ->
        {:ok, result.frobot.id}

      {:error, :frobot, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :xframe_inst, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :cannon_inst, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :scanner_inst, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :missile_inst, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :equip_xframe, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :equip_cannon, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :equip_scanner, %Ecto.Changeset{} = cs, _changes} ->
        return_errors(cs)

      {:error, :update_user, %Ecto.Changeset{} = cs, _changes} ->
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
          "reload_time" => 5
        },
        %{
          "cannon_id" => 2,
          "id" => 2,
          "image" => "https://via.placeholder.com/50.png",
          "magazine_size" => 2,
          "rate_of_fire" => 1,
          "reload_time" => 5
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
          "speed" => 400
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
          "scanner_id" => 1
        }
      ],
      "xframe_inst" => %{
        "accel_speed_mss" => 5,
        "health" => nil,
        "id" => 1,
        "image" => "https://via.placeholder.com/50.png",
        "max_health" => 100,
        "max_speed_ms" => 30,
        "max_throttle" => 100,
        "turn_speed" => 50,
        "xframe_id" => 1
      },
      "xp" => 0
     }
    ```

  """
  def get_frobot_details(id_or_name) do
    case Assets.get_frobot(id_or_name) do
      nil ->
        {:error, "There are no frobots with given id/name"}

      frobot ->
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
  def get_image_base_url() do
    s3_base_url = Application.get_env(:ex_aws, :s3)[:host]
    s3_bucket = Application.get_env(:ex_aws, :s3)[:bucket]

    {:ok, "https://#{s3_base_url}/#{s3_bucket}/images"}
  end

  def _preload_equipment_instances(frobot) do
    frobot
    |> Repo.preload(:xframe_inst)
    |> Repo.preload(:cannon_inst)
    |> Repo.preload(:scanner_inst)
    |> Repo.preload(:missile_inst)
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
      "bio" => frobot.bio
    }

    frobot_details =
      cond do
        frobot.class in [Assets.prototype_class(), Assets.target_class()] ->
          frobot_details

        true ->
          xframe_inst = _get_xframe_inst_details(frobot)
          cannon_inst = _get_cannon_inst_details(frobot)
          scanner_inst = _get_scanner_inst_details(frobot)
          missile_inst = _get_missile_inst_details(frobot)

          Map.put(frobot_details, "xframe_inst", xframe_inst)
          |> Map.put("cannon_inst", cannon_inst)
          |> Map.put("scanner_inst", scanner_inst)
          |> Map.put("missile_inst", missile_inst)
      end

    {:ok, frobot_details}
  end

  defp _get_xframe_inst_details(frobot) do
    if Map.has_key?(frobot, :xframe_inst) do
      %{
        "id" => frobot.xframe_inst.id,
        "xframe_id" => frobot.xframe_inst.xframe_id,
        "max_speed_ms" => frobot.xframe_inst.max_speed_ms,
        "turn_speed" => frobot.xframe_inst.turn_speed,
        "max_health" => frobot.xframe_inst.max_health,
        "health" => frobot.xframe_inst.health,
        "max_throttle" => frobot.xframe_inst.max_throttle,
        "accel_speed_mss" => frobot.xframe_inst.accel_speed_mss,
        "image" => frobot.xframe_inst.image
      }
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
            "image" => cannon_inst.image
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
            "image" => scanner_inst.image
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
            "image" => missile_inst.image
          }
        end)
      end
    else
      []
    end
  end

  defp update_user_changeset(user_id) do
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
end
