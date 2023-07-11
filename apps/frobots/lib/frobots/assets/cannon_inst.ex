defmodule Frobots.Assets.CannonInst do
  @moduledoc """
  The CannonInst context.
  """
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
    |> cast(attrs, @fields ++ [:user_id, :cannon_id, :frobot_id])
    |> validate_required(@fields)
  end
end
