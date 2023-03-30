defmodule Frobots.Api do
  alias Frobots.Events
  alias Frobots.Events.{Match, Slot}
  alias Frobots.Accounts.User

  alias Frobots.{Equipment, Accounts}

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

  def create_frobot(user, _name, _brain_code, _extra_params) when user.sparks == 0 do
    {:error, "User does not have enough sparks."}
  end

  def create_frobot(user, name, brain_code, _extra_params)
      when user.sparks > 0 and
             name === "" and
             brain_code === "" do
    IO.inspect("Name and prototype required")
    {:error, "Frobot name and braincode are required."}
  end

  @doc ~S"""
    Create Frobot
    We pass name and brain code so that we pattern match on required fieldsby checking guard functions

  """
  def create_frobot(user, name, brain_code, extra_params)
      when user.sparks > 0 and
             name !== "" and
             brain_code !== "" do
    # _default_loadout = Frobots.default_frobot_loadout()
    # extra_params may contain bio, pixellated_img, avatar, blockly_code
    frobot_attrs =
      Map.merge(extra_params, %{"name" => name, "brain_code" => brain_code, "class" => "U"})

    build_multi(user, frobot_attrs)
    |> run_multi()
  end

  @doc ~S"""

    This is called internally called from create_frobot to build an Ecto.multi structure.
    Building Ecto.multi structure in separate function makes testing easier.

    ex: multi_list = Api.build_multi(user, @valid_frobot_attrs) |> Ecto.Multi.to_list()

    Where multi_list is a list of changesets that can asserted for validity.

  """
  def build_multi(user, frobot_attrs) do
    Multi.new()
    |> Multi.insert(:frobot, create_frobot_changeset(user, frobot_attrs))
    |> Multi.insert(:xframe_inst, Equipment.create_equipment_changeset(user, "Xframe", :Tank_Mk1))
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
    This is function is called after build_multi.

    The actual db operations are run in this step as a transaction and any failures are rolld back.any()
    Function returns {:ok, frobot_id} or {:error, reason} to caller
  """
  def run_multi(multi) do
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
