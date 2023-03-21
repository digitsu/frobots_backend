defmodule Frobots.Assets.Cannon do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :cannon_type,
             :reload_time,
             :rate_of_fire,
             :magazine_size
           ]}

  schema "cannons" do
    field :cannon_type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :reload_time, :integer
    field :rate_of_fire, :integer
    field :magazine_size, :integer
    timestamps()
  end

  @fields [
    :cannon_type,
    :reload_time,
    :rate_of_fire,
    :magazine_size
  ]

  @doc false
  def changeset(cannon, attrs) do
    cannon
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:cannon_type])
  end
end

defmodule Frobots.Assets.CannonInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor


  @derive {Jason.Encoder,
           only: [
             :user,
             :cannon,
             :frobot,
             :reload_time,
             :rate_of_fire,
             :magazine_size
           ]}

  schema "cannon_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :cannon, Frobots.Assets.Cannon
    belongs_to :frobot, Frobots.Assets.Frobot
    field :reload_time, :integer
    field :rate_of_fire, :integer
    field :magazine_size, :integer
    timestamps()
  end

  @fields [
    :reload_time,
    :rate_of_fire,
    :magazine_size
  ]
  @doc false
  def changeset(cannon, attrs) do
    cannon
    |> Frobots.Repo.preload(:cannon)
    |> Frobots.Repo.preload(:frobot)
    |> cast_assoc(:cannon, with: &Frobots.Assets.Cannon.changeset/2 )
    |> cast_assoc(:frobot, with: &Frobots.Assets.Frobot.changeset/2)
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
