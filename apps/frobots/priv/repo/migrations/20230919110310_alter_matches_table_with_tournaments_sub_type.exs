defmodule Frobots.Repo.Migrations.AlterMatchesTableWithTournamentsSubType do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :tournament_match_sub_type, :integer
    end

    alter table(:tournament_players) do
      add :tournament_match_sub_type, :integer
    end
  end
end
