defmodule Frobots.Repo.Migrations.AddUniqueIndexScanner do
  use Ecto.Migration

  def change do
    create unique_index(:scanners, [:scanner_type])
  end
end
