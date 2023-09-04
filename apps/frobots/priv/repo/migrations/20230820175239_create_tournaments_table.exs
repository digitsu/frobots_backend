defmodule Frobots.Repo.Migrations.CreateTournamentsTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:tournaments) do
      add :name, :string
      add :description, :string
      add :starts_at, :integer
      add :ended_at, :integer
      add :prizes, {:array, :integer}
      add :commission_percent, :integer
      add :arena_fees_percent, :integer
      add :platform_fees, :integer
      add :entry_fees, :integer
      add :participants, :integer
      add :final_ranking, :map
      add :total_quedos, :integer
      add :payouts, :map
      add :status, :string

      timestamps()
    end
  end
end
