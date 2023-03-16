defmodule Frobots.Assets.Scanner do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :scanner_type,
             :max_range,
             :resolution
           ]}

  schema "scanner" do
    field :scanner_type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :max_range, :integer
    field :resolution, :integer
    timestamps()
  end

  @fields [
    :scanner_type,
    :max_range,
    :resolution
  ]

  @doc false
  def changeset(scanner, attrs) do
    scanner
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:scanner_type])
  end
end
