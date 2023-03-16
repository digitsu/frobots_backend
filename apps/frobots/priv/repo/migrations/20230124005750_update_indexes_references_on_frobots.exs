defmodule Frobots.Repo.Migrations.UpdateIndexesReferencesOnFrobots do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE frobots
             DROP CONSTRAINT IF EXISTS frobots_user_id_fkey"

    create index(:frobots, [:user_id])

    execute "ALTER TABLE frobots
             ADD CONSTRAINT frobots_user_id_fkey
             FOREIGN KEY (user_id)
             REFERENCES users(id)
             ON DELETE CASCADE"
  end

  def down do
    drop constraint("frobots", "frobots_user_id_fkey")
    drop index(:frobots, [:user_id])
  end
end
