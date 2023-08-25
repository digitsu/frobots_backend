defmodule Frobots.Events.Match do
  @moduledoc """
  The Match context.
  """
  # this defines a match
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Slot

  @fields [
    :title,
    :description,
    :match_time,
    :timer,
    :arena_id,
    :min_player_frobot,
    :max_player_frobot,
    :status,
    :frobots,
    :user_id,
    :type,
    :started_at,
    :reason
  ]

  @derive {Jason.Encoder, only: @fields}
  # a battlelog is written after a match is completed, and there are winners declared.
  schema "matches" do
    field :title, :string
    field :description, :string
    field :match_time, :utc_datetime
    field :timer, :integer, default: 3600
    field :started_at, :integer
    field :arena_id, :integer
    field :min_player_frobot, :integer
    field :max_player_frobot, :integer
    field :reason, Ecto.Enum, values: [:timeout]
    field :status, Ecto.Enum, values: [:pending, :running, :done, :cancelled, :aborted]
    field :type, Ecto.Enum, values: [:simulation, :real], default: :real

    field :tournament_match_type, Ecto.Enum, values: [:pool_a, :pool_b, :pool_c, :quarter_final, :semi_final, :final]
    field :tournament_match_id, :integer
    belongs_to :tournament, Frobots.Events.Tournament

    ## legacy column
    field :frobots, {:array, :integer}
    belongs_to :user, Frobots.Accounts.User
    embeds_one :match_template, Frobots.Events.MatchTemplate

    has_one :battlelog, Frobots.Events.Battlelog
    has_many :slots, Slot, foreign_key: :match_id

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, @fields)
    |> cast_embed(:match_template)
    |> cast_assoc(:slots, with: &Slot.changeset/2)
    |> validate_required([
      :status,
      :user_id,
      :match_time,
      :arena_id,
      :min_player_frobot,
      :max_player_frobot,
      :type
    ])
    |> unique_constraint([:battlelog])
  end

  def update_changeset(match, attrs) do
    match
    |> cast(attrs, [:status, :started_at, :reason, :type])
    |> cast_assoc(:slots, with: &Slot.update_changeset/2)
    |> validate_required([
      :status
    ])
    |> unique_constraint([:battlelog])
  end
end
