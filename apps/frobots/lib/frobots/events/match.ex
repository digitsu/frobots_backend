defmodule Frobots.Events.Match do
  # this defines a match
  use Ecto.Schema
  import Ecto.Changeset

  # a battlelog is written after a match is completed, and there are winners declared.
  schema "matches" do
    field :status, Ecto.Enum, values: [:pending, :running, :done, :timeout, :cancelled]
    field :frobots, {:array, :integer}
    embeds_one :match_template, Frobots.Events.MatchTemplate
    has_one :battlelog, Frobots.Events.Battlelog
    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:status, :frobots])
    |> cast_embed(:match_template, required: true)
    |> validate_required([:status, :frobots])
    |> unique_constraint([:battlelog])
  end
end
