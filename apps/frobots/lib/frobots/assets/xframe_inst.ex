defmodule Frobots.Assets.XframeInst do
  @moduledoc """
  The XframeInst context.
  """
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
             :max_health,
             :health,
             :max_throttle,
             :accel_speed_mss
           ]}

  schema "xframe_inst" do
    # note there are NO hardpoints or movement_type here. The instances can NEVER change these.
    # Refer back to the xframe class for them
    belongs_to(:user, Frobots.Accounts.User)
    belongs_to(:xframe, Frobots.Assets.Xframe)
    belongs_to(:frobot, Frobots.Assets.Frobot)
    field(:max_speed_ms, :integer)
    field(:turn_speed, :integer)
    field(:max_health, :integer)
    field(:health, :integer)
    field(:max_throttle, :integer)
    field(:accel_speed_mss, :integer)
    timestamps()
  end

  @fields [
    :max_speed_ms,
    :turn_speed,
    :max_health,
    :max_throttle,
    :accel_speed_mss
  ]

  @doc false
  def changeset(xframe, attrs) do
    xframe
    |> cast(attrs, @fields ++ [:xframe_id, :user_id, :health, :frobot_id])
    |> validate_required(@fields)
  end
end
