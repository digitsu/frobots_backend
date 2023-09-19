defmodule Frobots.Events.TournamentPlayers do
  @moduledoc """
  The TournamentPlayers context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Tournament
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder,
           only: [:tournament_id, :frobot_id, :score, :tournament_match_type, :order]}
  schema "tournament_players" do
    belongs_to(:frobot, Frobot)
    belongs_to(:tournament, Tournament)
    field :score, :integer

    field :tournament_match_type, Ecto.Enum,
      values: [:pool, :knockout, :qualifier, :semi_final, :eliminator, :final]

    field :tournament_match_sub_type, :string
    field :order, :integer
    timestamps()
  end

  @fields [:frobot_id, :tournament_id, :score, :tournament_match_type, :tournament_match_sub_type]

  @doc false
  def changeset(tournament_player, attrs) do
    tournament_player
    |> cast(attrs, @fields ++ [:order])
    |> validate_required(@fields)
  end

  def update_changeset(tournament_player, attrs) do
    tournament_player
    |> cast(attrs, [:order, :score, :tournament_match_type, :tournament_match_sub_type])
    |> validate_required(@fields)
  end
end
