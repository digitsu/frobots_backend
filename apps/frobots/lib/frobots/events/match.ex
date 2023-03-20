defmodule Frobots.Events.Match do
  # this defines a match
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Slot

  # a battlelog is written after a match is completed, and there are winners declared.
  schema "matches" do
    field :title, :string
    field :description, :string
    field :match_time, :utc_datetime
    field :timer, :integer
    field :arena_id, :integer
    field :min_player_frobot, :integer
    field :max_player_frobot, :integer
    field :status, Ecto.Enum, values: [:pending, :running, :done, :timeout, :cancelled]

    ## legacy column
    field :frobots, {:array, :integer}
    belongs_to :user, Frobots.Accounts.User
    embeds_one :match_template, Frobots.Events.MatchTemplate

    has_one :battlelog, Frobots.Events.Battlelog
    has_many :slots, Slot

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
    :frobots
  ]

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, @fields)
    |> cast_embed(:match_template, required: true)
    |> validate_required([:status])
    |> unique_constraint([:battlelog])
  end
end
