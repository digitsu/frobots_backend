defmodule Frobots.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :status, :string
      add :match_template, :map
      timestamps()
    end

    create table(:battlelogs) do
      add :winners, {:array, :integer}
      add :qudos_pool, :integer
      add :payouts, {:array, :integer}
      add :odds, {:array, :float}
      add :commission_paid, :integer
      add :match_id, references(:matches, on_delete: :nothing)
      timestamps()
    end

    create_if_not_exists index(:battlelogs, [:match_id])

    create table(:frobots_battlelogs) do
      add :battlelog_id, references(:battlelogs)
      add :frobot_id, references(:frobots)
      timestamps()
    end
  end
end
