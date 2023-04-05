defmodule Frobots.Events.Match do
  # this defines a match
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Slot

  @derive Jason.Encoder
  # a battlelog is written after a match is completed, and there are winners declared.
  schema "matches" do
    field :title, :string
    field :description, :string
    field :match_time, :utc_datetime
    field :timer, :integer, default: 3600
    field :arena_id, :integer
    field :min_player_frobot, :integer
    field :max_player_frobot, :integer
    field :status, Ecto.Enum, values: [:pending, :running, :done, :timeout, :cancelled]
    field :type, Ecto.Enum, values: [:simulation, :real], default: :real

    ## legacy column
    field :frobots, {:array, :integer}
    belongs_to :user, Frobots.Accounts.User
    embeds_one :match_template, Frobots.Events.MatchTemplate

    has_one :battlelog, Frobots.Events.Battlelog
    has_many :slots, Slot, foreign_key: :match_id

    timestamps()
  end

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
    :type
  ]

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
    IO.inspect(match, label: "Match in Update")

    match
    |> cast(attrs, [:status])
    |> cast_assoc(:slots, with: &Slot.update_changeset/2)
    |> validate_required([
      :status
    ])
    |> unique_constraint([:battlelog])
  end
end
