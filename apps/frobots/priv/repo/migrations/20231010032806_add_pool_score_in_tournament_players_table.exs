defmodule Frobots.Repo.Migrations.AddPoolScoreInTournamentPlayersTable do
  use Ecto.Migration

  def change do
    alter table(:tournament_players) do
      add :pool_score, :integer
    end
  end
end
