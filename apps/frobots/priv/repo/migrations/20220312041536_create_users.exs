defmodule Frobots.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end
    create unique_index(:users, [:username, :email])
  end
end
