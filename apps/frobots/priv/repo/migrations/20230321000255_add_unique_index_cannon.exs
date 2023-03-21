defmodule Frobots.Repo.Migrations.AddUniqueIndexCannon do
  use Ecto.Migration

  def change do
    create unique_index(:cannons, [:cannon_type])
  end
end
