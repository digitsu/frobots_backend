defmodule Frobots.Repo.Migrations.AddUserIdToLeaderboardStats do
  use Ecto.Migration

  def up do
    alter table(:leaderboard_stats) do
      add :user_id, :integer
    end
  end

  def down do
    alter table(:leaderboard_stats) do
      remove :user_id
    end
  end
end
