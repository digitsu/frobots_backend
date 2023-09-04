defmodule Frobots.Repo.Migrations.CreateTournamentPlayersTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:tournament_players) do
      add :frobot_id, references(:frobots, on_delete: :nothing)
      add :tournament_id, references(:tournaments, on_delete: :nothing)
      add :score, :integer
      add :tournament_match_type, :string

      timestamps()
    end
  end
end
