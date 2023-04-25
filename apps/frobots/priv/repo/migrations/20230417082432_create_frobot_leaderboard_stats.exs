defmodule Frobots.Repo.Migrations.CreateFrobotLeaderboardStats do
  use Ecto.Migration

  def change do
    create table(:leaderboard_stats) do
      add :points, :integer
      add :xp, :integer
      add :attempts, :integer
      add :matches_won, :integer
      add :matches_participated, :integer
      add :frobot_id, references(:frobots, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:leaderboard_stats, :frobot_id, name: :unique_frobot_id)
  end
end
