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
             :image_path
           ]}

  schema "cannons" do
    field :type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :reload_time, :integer
    field :rate_of_fire, :integer
    field :magazine_size, :integer
    field :image_path, :string
    has_many :cannon_inst, Frobots.Assets.CannonInst
    timestamps()
  end

  @fields [
    :type,
    :reload_time,
    :rate_of_fire,
    :magazine_size,
    :image_path
  ]

  @doc false
  def changeset(cannon, attrs) do
    cannon
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
