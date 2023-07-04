defmodule Frobots.Repo.Migrations.AlterScannerrTable do
  use Ecto.Migration

  def change do
    alter table(:scanners) do
      add :special, :string
    end
  end
end
