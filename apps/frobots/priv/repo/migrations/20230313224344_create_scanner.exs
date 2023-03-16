defmodule Frobots.Repo.Migrations.CreateScanner do
  use Ecto.Migration

  def change do
    create table(:scanners) do
      add :scanner_type, :string
      add :max_range, :integer
      add :resolution, :integer
      timestamps()
    end
  end
end
