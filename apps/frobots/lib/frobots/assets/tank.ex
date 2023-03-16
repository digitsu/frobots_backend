defmodule Frobots.Assets.Tank do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :tank_type,
             :max_speed_ms,
             :turn_speed,
             :scanner_hardpoint,
             :weapon_hardpoint,
             :movement_type,
             :max_health,
             :max_throttle,
             :accel_speed_mss
           ]}

  schema "tanks" do
    field :tank_type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :max_speed_ms, :integer
    field :turn_speed, :integer
    field :scanner_hardpoint, :integer
    field :weapon_hardpoint, :integer
    field :movement_type, Ecto.Enum, values: ~w(tread bipedal hover)a
    field :max_health, :integer
    field :max_throttle, :integer
    field :accel_speed_mss, :integer

    timestamps()
  end

  @fields [
    :tank_type,
    :max_speed_ms,
    :turn_speed,
    :scanner_hardpoint,
    :weapon_hardpoint,
    :movement_type,
    :max_health,
    :max_throttle,
    :accel_speed_mss
  ]

  @doc false
  def changeset(tank, attrs) do
    tank
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:tank_type])
  end
end
