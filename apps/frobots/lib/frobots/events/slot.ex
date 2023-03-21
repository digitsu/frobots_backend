defmodule Frobots.Events.Slot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder, only: [:status, :match_id, :frobot_id, :slot_type]}

  schema "slots" do
    field(:slot_type, Ecto.Enum, values: [:host, :protobot, :closed])
    field(:status, Ecto.Enum, values: [:open, :closed, :joining, :ready])

    belongs_to(:frobot, Frobot)
    belongs_to(:match, Match)
    timestamps()
  end

  @fields [:status, :slot_type]

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, @fields ++ [:frobot_id])
    |> cast_assoc(:match)
    |> validate_required(@fields)
  end
end
