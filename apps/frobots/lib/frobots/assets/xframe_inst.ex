defmodule Frobots.Assets.XframeInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user_id,
             :xframe_id,
             :frobot_id,
             :max_speed_ms,
             :turn_speed,
             :sensor_hardpoints,
             :weapon_hardpoints,
             :cpu_hardpoints,
             :movement_type,
             :max_health,
             :max_throttle,
             :accel_speed_mss
           ]}

  schema "xframe_inst" do
    belongs_to(:user, Frobots.Accounts.User)
    belongs_to(:xframe, Frobots.Assets.Xframe)
    belongs_to(:frobot, Frobots.Assets.Frobot)
    field(:max_speed_ms, :integer)
    field(:turn_speed, :integer)
    field(:sensor_hardpoints, :integer)
    field(:weapon_hardpoints, :integer)
    field(:cpu_hardpoints, :integer)
    field(:movement_type, Ecto.Enum, values: ~w(tracks bipedal hover)a)
    field(:max_health, :integer)
    field(:max_throttle, :integer)
    field(:accel_speed_mss, :integer)





    timestamps()
  end

  @fields [
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
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
