defmodule Frobots.Repo.Migrations.AddSparxToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sparx, :integer, default: 6
    end
  end
end
