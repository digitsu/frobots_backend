defmodule Frobots.Events.Tournament do
  @moduledoc """
  The Tournament context.
  """
  # this defines a tournament
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match

  @derive Jason.Encoder

  schema "tournaments" do
    field :name, :string
    field :starts_at, :integer
    field :ended_at, :integer
    field :description, :string
    field :prizes, {:array, :integer}
    field :commission_percent, :integer
    field :arena_fees_percent, :integer
    field :platform_fees, :integer
    field :entry_fees, :integer
    field :participants, :integer

    ## Once the tournament is Over calculate these
    field :final_ranking, :map
    field :total_quedos, :integer
    field :payouts, :map
    field :status, Ecto.Enum, values: [:open, :progress, :completed, :cancelled]

    has_many :matches, Match, foreign_key: :tournament_id

    timestamps()
  end

  @fields [
    :name,
    :starts_at,
    :description,
    :prizes,
    :commission_percent,
    :arena_fees_percent,
    :platform_fees,
    :entry_fees
  ]

  @optional_fields [
    :ended_at,
    :participants,
    :final_ranking,
    :total_quedos,
    :payouts,
    :status
  ]

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, @fields ++ @optional_fields)
    |> validate_required(@fields)
  end
end
