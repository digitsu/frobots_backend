defmodule Frobots.Repo.Migrations.SetSparks do
  use Ecto.Migration

  def up do
    execute "UPDATE users SET sparks=6 where sparks IS NULL"
  end

  def down do
    IO.inspect("No rollback")
  end
end
