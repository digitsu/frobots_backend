defmodule :"Elixir.Frobots.Repo.Migrations.RenameXframeFields" do
  use Ecto.Migration

  def change do
  end

  def up do
    execute "ALTER TABLE xframes RENAME COLUMN scanner_hardpoint TO sensor_hardpoints"
    execute "ALTER TABLE xframes RENAME COLUMN weapon_hardpoint TO weapon_hardpoints"
    execute "ALTER TABLE xframes ADD COLUMN cpu_hardpoints integer"
  end

  def down do
    execute "ALTER TABLE xframes RENAME COLUMN sensor_hardpoints TO scanner_hardpoint"
    execute "ALTER TABLE xframes RENAME COLUMN weapon_hardpoints TO weapon_hardpoint"
    execute "ALTER TABLE xframes DROP COLUMN cpu_hardpoints"
  end
end
