defmodule Frobots.Events.Tournament do
  @moduledoc """
  The Tournament context.
  """
  # this defines a tournament
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match
  alias Frobots.Events.TournamentPlayers

  @derive Jason.Encoder

  schema "tournaments" do
    field(:name, :string)
    field(:starts_at, :integer)
    field(:ended_at, :integer)
    field(:description, :string)
    field(:prizes, {:array, :integer})
    field(:commission_percent, :integer)
    field(:arena_fees_percent, :integer)
    field(:arena_id, :integer)
    field(:bonus_percent, :integer)
    field(:entry_fees, :integer)
    field(:min_participants, :integer)

    ## Once the tournament is Over calculate these
    field(:final_ranking, :map)
    field(:total_quedos, :integer)
    field(:payouts, :map)
    field(:status, Ecto.Enum, values: [:open, :inprogress, :completed, :cancelled])

    has_many(:matches, Match, foreign_key: :tournament_id)
    has_many(:tournament_players, TournamentPlayers, foreign_key: :tournament_id)

    timestamps()
  end

  @fields [
    :name,
    :starts_at,
    :description,
    :prizes,
    :min_participants,
    :commission_percent,
    :arena_fees_percent,
    :bonus_percent,
    :entry_fees,
    :status,
    :arena_id
  ]

  @optional_fields [
    :ended_at,
    :final_ranking,
    :total_quedos,
    :payouts
  ]

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, @fields ++ @optional_fields)
    |> validate_required(@fields)
    |> unique_constraint(:name)
  end

  def update_changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:status] ++ @optional_fields)
    |> validate_required(@fields)
  end
end
