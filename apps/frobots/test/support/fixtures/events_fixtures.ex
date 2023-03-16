defmodule Frobots.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Frobots.Events.Battlelogs` context.
  """
  alias Frobots.Events.Match

  @battlelog_params %{
    winners: [1, 3],
    qudos_pool: 100,
    payouts: [90, 10],
    odds: [0.1, 0.6, 0.3, 0.8],
    commission_paid: 20,
    frobots: ["rabbit", "rook", "random", "tracker"]
  }

  # because these come from channel, is a string_map
  @match_template %{
    "entry_fee" => 100,
    "commission_rate" => 10,
    "match_type" => "individual",
    # winner take all
    "payout_map" => [100],
    "max_frobots" => 4,
    "min_frobots" => 2
  }

  def match_fixture(attrs \\ %{}) do
    Enum.into(attrs, @match_template)
    |> Frobots.Events.create_match()
  end

  @doc """
  Generate a battlelog.
  """
  def battlelog_fixture(%Match{} = match, attrs \\ %{}) do
    attrs = Enum.into(attrs, @battlelog_params)
    Frobots.Events.create_battlelog(match, attrs)
  end
end
