defmodule Frobots.Assets.Equipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "equipment" do
    field :equipment_id, :integer
    field :equipment_type, Ecto.Enum, values: ~w(Cannon Tank Scanner Missile)a
    field :frobot_id, :integer
    timestamps()
  end

  @doc false
  def changeset(battlelog, attrs) do
    battlelog
    |> cast(attrs, [:equipment_id, :equipment_type, :frobot_id])
    |> validate_required([:equipment_id, :equipment_type, :frobot_id])
  end
end
