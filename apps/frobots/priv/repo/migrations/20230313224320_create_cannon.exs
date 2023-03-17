defmodule Frobots.Repo.Migrations.CreateCannon do
  use Ecto.Migration

  def change do
    create table(:cannons) do
      add :cannon_type, :string
      add :reload_time, :integer
      add :rate_of_fire, :integer
      add :magazine_size, :integer
      timestamps()
    end
  end
end
