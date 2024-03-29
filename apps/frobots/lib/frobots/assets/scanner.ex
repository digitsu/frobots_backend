defmodule Frobots.Assets.Scanner do
  @moduledoc """
  The Scanner context.
  """
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :max_range,
             :resolution,
             :image,
             :special
           ]}

  schema "scanners" do
    field :type, Ecto.Enum, values: ~w(Mk1 Mk2 Mk3)a
    field :special, Ecto.Enum, values: ~w(active passive)a
    field :max_range, :integer
    field :resolution, :integer
    has_many :scanner_inst, Frobots.Assets.ScannerInst
    field :class, Ecto.Enum, values: ~w(scanner)a
    field :image, :string, default: "https://via.placeholder.com/50.png"
    timestamps()
  end

  @fields [
    :type,
    :max_range,
    :resolution,
    :class,
    :special
  ]

  @doc false
  def changeset(scanner, attrs) do
    scanner
    |> cast(attrs, @fields ++ [:image])
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
