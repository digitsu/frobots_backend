defmodule Frobots.Repo.Migrations.AddStartedAtForMatchesTable do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :started_at, :integer
    end
  end
end
