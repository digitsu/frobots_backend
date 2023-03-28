defmodule Frobots.Assets.Scanner do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :max_range,
             :resolution
           ]}

  schema "scanners" do
    field :type, Ecto.Enum, values: ~w(Mk1 Mk2)a
    field :max_range, :integer
    field :resolution, :integer
    has_many :scanner_inst, Frobots.Assets.ScannerInst
    timestamps()
  end

  @fields [
    :type,
    :max_range,
    :resolution,
  ]

  @doc false
  def changeset(scanner, attrs) do
    scanner
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
