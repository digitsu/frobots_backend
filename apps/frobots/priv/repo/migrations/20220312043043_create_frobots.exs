defmodule Frobots.Repo.Migrations.CreateFrobots do
  use Ecto.Migration

  def change do
    create table(:frobots) do
      add :name, :string
      add :brain_code, :text
      add :xp, :integer
      add :class, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:frobots, [:user_id])
  end
end
