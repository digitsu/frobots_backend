defmodule Frobots.Repo.Migrations.AlterMatchesTableWithTournaments do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :tournament_match_type, :string
      add :tournament_match_id, :integer
      add :tournament_id, references(:tournaments, on_delete: :nothing)
    end
  end
end
