defmodule Frobots.Repo.Migrations.RemoveXframeInstanceFields do
  use Ecto.Migration

  def change do
    alter table(:xframe_inst) do
      remove :weapon_hardpoint
      remove :scanner_hardpoint
    end
  end
end
