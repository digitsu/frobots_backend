defmodule Frobots.Repo.Migrations.AddUniqueIndexMissile do
  use Ecto.Migration

  def change do
    create unique_index(:missiles, [:missile_type])
  end
end
