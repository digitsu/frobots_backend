defmodule Frobots.Assets.Missile do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :damage_direct,
             :damage_near,
             :damage_far,
             :speed,
             :range,
             :image
           ]}

  schema "missiles" do
    field :type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :damage_direct, {:array, :integer}
    field :damage_near, {:array, :integer}
    field :damage_far, {:array, :integer}
    field :speed, :integer
    field :range, :integer
    has_many :missile_inst, Frobots.Assets.MissileInst
    field :class, Ecto.Enum, values: ~w(missile)a
    field :image, :string, default: "https://via.placeholder.com/50.png"
    timestamps()
  end

  @fields [
    :type,
    :damage_direct,
    :damage_near,
    :damage_far,
    :speed,
    :range,
    :image
  ]

  @doc false
  def changeset(missile, attrs) do
    missile
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
