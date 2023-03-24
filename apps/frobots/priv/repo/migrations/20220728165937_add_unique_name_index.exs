defmodule Frobots.Repo.Migrations.AddUniqueNameIndex do
  use Ecto.Migration

  def change do
    create_if_not_exists unique_index(:users, [:name])
  end
end
