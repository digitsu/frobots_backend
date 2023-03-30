defmodule Frobots.Repo.Migrations.AddDamageMap do
  use Ecto.Migration

  def change do
    alter table(:battlelogs) do
      add :death_map, :json
    end
  end
end
