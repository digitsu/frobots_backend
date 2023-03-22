defmodule Frobots.Repo.Migrations.AlterMatchesTable do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :user_id, references(:users, on_delete: :nothing)
      add :title, :string
      add :description, :string
      add :match_time, :utc_datetime
      add :timer, :integer
      add :arena_id, :integer
      add :min_player_frobot, :integer
      add :max_player_frobot, :integer
    end
  end
end
