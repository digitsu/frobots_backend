defmodule Frobots.Assets.MissileInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user_id,
             :missile_id,
             :frobot_id,
             :damage_direct,
             :damage_near,
             :damage_far,
             :speed,
             :range,
             :image
           ]}

  schema "missile_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :missile, Frobots.Assets.Missile
    belongs_to :frobot, Frobots.Assets.Frobot
    field :damage_direct, {:array, :integer}
    field :damage_near, {:array, :integer}
    field :damage_far, {:array, :integer}
    field :speed, :integer
    field :range, :integer
    field :image, :string, default: "https://via.placeholder.com/50.png"
    timestamps()
  end

  @fields [
    :damage_direct,
    :damage_near,
    :damage_far,
    :speed,
    :range
  ]

  @doc false
  def changeset(missile, attrs) do
    missile
    |> cast(attrs, @fields ++ [:frobot_id, :image])
    |> validate_required(@fields)
  end
end
