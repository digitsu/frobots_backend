defmodule Frobots.Assets.XFrame do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :xframe_type,
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

  schema "xframes" do
    field :xframe_type, Ecto.Enum, values: ~w(Tank_Mk1 Tank_Mk2 Tank_Mk3)a
    field :max_speed_ms, :integer
    field :turn_speed, :integer
    field :sensor_hardpoints, :integer
    field :weapon_hardpoints, :integer
    field :cpu_hardpoints, :integer
    field :movement_type, Ecto.Enum, values: ~w(tracks bipedal hover)a
    field :max_health, :integer
    field :max_throttle, :integer
    field :accel_speed_mss, :integer

    timestamps()
  end

  @fields [
    :xframe_type,
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
    |> unique_constraint([:xframe_type])
  end
end

defmodule Frobots.Assets.XFrameInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user,
             :xframe,
             :frobot,
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
    belongs_to :user, Frobots.Accounts.User
    belongs_to :xframe, Frobots.Assets.XFrame
    belongs_to :frobot, Frobots.Assets.Frobot
    field :max_speed_ms, :integer
    field :turn_speed, :integer
    field :sensor_hardpoints, :integer
    field :weapon_hardpoints, :integer
    field :cpu_hardpoints, :integer
    field :movement_type, Ecto.Enum, values: ~w(tracks bipedal hover)a
    field :max_health, :integer
    field :max_throttle, :integer
    field :accel_speed_mss, :integer

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
    |> cast_assoc(:user, with: &Frobots.Accounts.User.validate_email/1 )
    |> cast_assoc(:xframe, with: &Frobots.Assets.XFrame.changeset/2 )
    |> cast_assoc(:frobot, with: &Frobots.Assets.Frobot.changeset/2)
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
