defmodule Frobots.Assets.ScannerInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user_id,
             :scanner_id,
             :frobot_id,
             :max_range,
             :resolution,
             :image
           ]}

  schema "scanner_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :scanner, Frobots.Assets.Scanner
    belongs_to :frobot, Frobots.Assets.Frobot
    field :max_range, :integer
    field :resolution, :integer
    field :image, :string, default: "https://via.placeholder.com/50.png"
    timestamps()
  end

  @fields [
    :max_range,
    :resolution,
    :image
  ]

  @doc false
  def changeset(scanner, attrs) do
    scanner
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
