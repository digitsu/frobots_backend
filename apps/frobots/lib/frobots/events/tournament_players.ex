defmodule Frobots.Events.TournamentPlayers do
  @moduledoc """
  The TournamentPlayers context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Tournament
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder, only: [:tournament_id, :frobot_id]}
  schema "tournament_players" do
    belongs_to(:frobot, Frobot)
    belongs_to(:tournament, Tournament)

    field :score, :integer

    field :tournament_match_type, Ecto.Enum,
      values: [:pool_a, :pool_b, :pool_c, :quarter_final, :semi_final, :final]

    field :order, :integer
    timestamps()
  end

  @fields [:frobot_id, :tournament_id, :score, :tournament_match_type]

  @doc false
  def changeset(tournament_player, attrs) do
    tournament_player
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
