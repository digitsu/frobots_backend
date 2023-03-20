defmodule Frobots.Assets.Missile do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :missile_type,
             :damage_direct,
             :damage_near,
             :damage_far,
             :speed,
             :range
           ]}

  schema "missiles" do
    field :missile_type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :damage_direct, {:array, :integer}
    field :damage_near, {:array, :integer}
    field :damage_far, {:array, :integer}
    field :speed, :integer
    field :range, :integer
    timestamps()
  end

  @fields [
    :missile_type,
    :damage_direct,
    :damage_near,
    :damage_far,
    :speed,
    :range
  ]

  @doc false
  def changeset(missile, attrs) do
    missile
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:missile_type])
  end
end

defmodule Frobots.Assets.MissileInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [

             :damage_direct,
             :damage_near,
             :damage_far,
             :speed,
             :range
           ]}

  schema "missiles" do
    field :missile_type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :damage_direct, {:array, :integer}
    field :damage_near, {:array, :integer}
    field :damage_far, {:array, :integer}
    field :speed, :integer
    field :range, :integer
    timestamps()
  end

  @fields [
    :missile_type,
    :damage_direct,
    :damage_near,
    :damage_far,
    :speed,
    :range
  ]

  @doc false
  def changeset(missile, attrs) do
    missile
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:missile_type])
  end
end
