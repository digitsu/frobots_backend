defmodule Frobots.Repo.Migrations.RemoveXframeInstanceFields do
  use Ecto.Migration

  def up do
    alter table(:xframe_inst) do
      remove :weapon_hardpoint
      remove :scanner_hardpoint
    end
  end
  def down do
    alter table(:xframe_inst) do
      add :weapon_hardpoint, :integer
      add :scanner_hardpoint, :integer
    end
  end
end
