defmodule Frobots.Repo.Migrations.UpdateEquipmentClasses do
  use Ecto.Migration

  def up do
    execute "update cannons set class = 'cannon' returning cannons.id, cannons.type, cannons.class"

    execute "update scanners set class = 'scanner' returning scanners.id, scanners.type, scanners.class"

    execute "update missiles set class = 'missile' returning missiles.id, missiles.type, missiles.class"

    execute "update xframes set class = 'xframe' returning xframes.id, xframes.type, xframes.class"
  end
  def down do
    IO.inspect("no rollback")
  end
end
