defmodule Frobots.Repo.Migrations.RenameEquipmentTypeField do
  use Ecto.Migration

  def change do
    drop index(:xframes, [:xframe_type])
    rename table("cannons"), :cannon_type, to: :type
    rename table("missiles"), :missile_type, to: :type
    rename table("scanners"), :scanner_type, to: :type
    rename table("xframes"), :xframe_type, to: :type
  end
end
