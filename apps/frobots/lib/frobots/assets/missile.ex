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
             :user,
             :missile,
             :frobot,
             :damage_direct,
             :damage_near,
             :damage_far,
             :speed,
             :range
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
    |> cast_assoc(:user, with: &Frobots.Accounts.User.validate_email/1 )
    |> cast_assoc(:missile, with: &Frobots.Assets.Missile.changeset/2 )
    |> cast_assoc(:frobot, with: &Frobots.Assets.Frobot.changeset/2)
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
