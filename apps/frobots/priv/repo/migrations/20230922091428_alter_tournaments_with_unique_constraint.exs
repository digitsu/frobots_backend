defmodule Frobots.Repo.Migrations.AlterTournamentsWithUniqueConstraint do
  use Ecto.Migration

  def change do
    create_if_not_exists unique_index(:tournaments, [:name])
  end
end
