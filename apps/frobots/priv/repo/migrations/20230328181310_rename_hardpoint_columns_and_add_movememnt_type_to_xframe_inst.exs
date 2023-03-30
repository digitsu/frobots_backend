defmodule Frobots.Repo.Migrations.RenameHardpointColumnsAndAddMovememntTypeToXframeInst do
  use Ecto.Migration

  def change do
  end

  def up do
    execute "ALTER TABLE xframe_inst RENAME COLUMN scanner_hardpoint TO sensor_hardpoints"
    execute "ALTER TABLE xframe_inst RENAME COLUMN weapon_hardpoint TO weapon_hardpoints"
    execute "ALTER TABLE xframe_inst ADD COLUMN cpu_hardpoints integer"
    execute "ALTER TABLE xframe_inst ADD COLUMN movement_type varchar"
  end

  def down do
    execute "ALTER TABLE xframe_inst RENAME COLUMN sensor_hardpoints TO scanner_hardpoint"
    execute "ALTER TABLE xframe_inst RENAME COLUMN weapon_hardpoints TO weapon_hardpoint"
    execute "ALTER TABLE xframe_inst DROP COLUMN cpu_hardpoints"
    execute "ALTER TABLE xframe_inst DROP COLUMN movement_type"
  end
end
