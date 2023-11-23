defmodule Frobots.Repo.Migrations.AlterTournamentPlayerMatchSubtype do
  use Ecto.Migration

  def change do
    alter table(:tournament_players) do
      modify :tournament_match_sub_type, :integer
    end
  end
end
