defmodule Frobots.Assets.Scanner do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :scanner_type,
             :max_range,
             :resolution
           ]}

  schema "scanners" do
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

defmodule Frobots.Assets.ScannerInst do
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user,
             :scanner,
             :frobot,
             :max_range,
             :resolution
           ]}

  schema "scanner_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :scanner, Frobots.Assets.Scanner
    belongs_to :frobot, Frobots.Assets.Frobot
    field :max_range, :integer
    field :resolution, :integer
    timestamps()
  end

  @fields [
    :max_range,
    :resolution
  ]

  @doc false
  def changeset(scanner, attrs) do
    scanner
    |> cast_assoc(:user, with: &Frobots.Accounts.User.validate_email/1 )
    |> cast_assoc(:scanner, with: &Frobots.Assets.Scanner.changeset/2 )
    |> cast_assoc(:frobot, with: &Frobots.Assets.Frobot.changeset/2)
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
