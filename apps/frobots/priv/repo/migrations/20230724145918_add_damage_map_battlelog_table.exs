defmodule Frobots.Repo.Migrations.AddDamageMapBattlelogTable do
  use Ecto.Migration

  def change do
    alter table(:battlelogs) do
      add :damage_map, :json
    end
  end
end
