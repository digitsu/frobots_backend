defmodule Frobots.Repo.Migrations.FixProtoFrobotClass do
  use Ecto.Migration

  def up do
    execute "update frobots set class = 'P' where name = 'rabbit' or name = 'tracker' or name = 'random' or name = 'rook' or name = 'sniper'"
    execute "update frobots set class = 'T' where name = 'target' or name = 'dummy'"
  end

  def down do
    IO.puts("No rollback needed")
  end
end
