defmodule Frobots.Api do
  alias Frobots.Events
  alias Frobots.Events.Match
  alias Frobots.Accounts.User

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

  def join_match(_user, _match) do
  end

  def create_frobot(_user, _name, _prototype) do
    _default_loadout = Frobots.default_frobot_loadout()

    # check that the user has enough sparks to create a frobot
    # create a frobot, with that name, using that prototype bot (name)
    # equip the frobot will all the default parts and xframe
    # create all the needed parts instances
    # save it into the db
    # IF successful, UPDATE the user and decrement sparks - 1.
    # return a frobot_name and id as success
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
end
