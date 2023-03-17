defmodule Frobots.Repo.Migrations.AddPasswordHashOldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hashed_password_old, :string
      add :migrated_user, :boolean, default: false
    end
  end
end
