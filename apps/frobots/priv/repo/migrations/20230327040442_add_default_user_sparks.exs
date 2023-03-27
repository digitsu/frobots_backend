defmodule Frobots.Repo.Migrations.AddDefaultUserSparks do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sparks, :integer, default: 6
    end
  end
end
