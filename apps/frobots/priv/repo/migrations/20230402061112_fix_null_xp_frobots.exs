defmodule Frobots.Repo.Migrations.FixNullXPFrobots do
  use Ecto.Migration

  def up do
    execute "UPDATE frobots SET xp = 0 WHERE xp IS NULL RETURNING name"
  end

  def down do
    IO.inspect("Nothing to Rollback;")
  end
end
