defmodule Frobots.Assets.Xframe do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :max_speed_ms,
             :turn_speed,
             :sensor_hardpoints,
             :weapon_hardpoints,
             :cpu_hardpoints,
             :movement_type,
             :max_health,
             :max_throttle,
             :accel_speed_mss,
             :image
           ]}

  schema "xframes" do
    field(:type, Ecto.Enum, values: ~w(Chassis_Mk1 Chassis_Mk2 Chassis_Mk3)a)
    field(:max_speed_ms, :integer)
    field(:turn_speed, :integer)
    field(:sensor_hardpoints, :integer)
    field(:weapon_hardpoints, :integer)
    field(:cpu_hardpoints, :integer)
    field(:movement_type, Ecto.Enum, values: ~w(tracks bipedal hover)a)
    field(:max_health, :integer)
    field(:max_throttle, :integer)
    field(:accel_speed_mss, :integer)
    field(:image, :string, default: "https://via.placeholder.com/50.png")
    has_many(:xframe_inst, Frobots.Assets.XframeInst)
    field(:class, Ecto.Enum, values: ~w(xframe)a)

    timestamps()
  end

  @fields [
    :type,
    :max_speed_ms,
    :turn_speed,
    :sensor_hardpoints,
    :weapon_hardpoints,
    :movement_type,
    :max_health,
    :max_throttle,
    :accel_speed_mss
  ]

  @doc false
  def changeset(xframe, attrs) do
    xframe
    |> cast(attrs, @fields ++ [:image])
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
