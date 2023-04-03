defmodule Frobots.Assets.CannonInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user_id,
             :cannon_id,
             :frobot_id,
             :reload_time,
             :rate_of_fire,
             :magazine_size,
             :image
           ]}

  schema "cannon_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :cannon, Frobots.Assets.Cannon
    belongs_to :frobot, Frobots.Assets.Frobot
    field :reload_time, :integer
    field :rate_of_fire, :integer
    field :magazine_size, :integer
    field :image, :string, default: "https://via.placeholder.com/50.png"
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
    |> cast(attrs, @fields ++ [:image])
    |> validate_required(@fields)
  end
end
