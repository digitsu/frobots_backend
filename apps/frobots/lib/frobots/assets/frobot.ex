defmodule Frobots.Assets.Frobot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frobots" do
    field :name, :string
    field :brain_code, :string
    field :class, :string
    field :xp, :integer
    belongs_to :user, Frobots.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(frobot, attrs) do
    frobot
    |> cast(attrs, [:brain_code, :class, :name, :xp])
    |> validate_required([:brain_code, :name])
  end
end
