defmodule Frobots.Assets.Cannon do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :reload_time,
             :rate_of_fire,
             :magazine_size,
             :image
           ]}

  schema "cannons" do
    field :type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :reload_time, :integer
    field :rate_of_fire, :integer
    field :magazine_size, :integer
    field :image, :string, default: "https://via.placeholder.com/50.png"
    has_many :cannon_inst, Frobots.Assets.CannonInst
    field :class, Ecto.Enum, values: ~w(cannon)a
    timestamps()
  end

  @fields [
    :type,
    :reload_time,
    :rate_of_fire,
    :magazine_size,
    :image
  ]

  @doc false
  def changeset(cannon, attrs) do
    cannon
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
