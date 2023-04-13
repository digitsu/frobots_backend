defmodule Frobots.Repo.Migrations.AddEquipmentFrobotIndexes do
  use Ecto.Migration

  def change do
    create_if_not_exists index(:xframe_inst, [:frobot_id])
    create_if_not_exists index(:scanner_inst, [:frobot_id])
    create_if_not_exists index(:cannon_inst, [:frobot_id])
    create_if_not_exists index(:missile_inst, [:frobot_id])

    alter table(:cannons) do
      add :class, :string
    end

    alter table(:missiles) do
      add :class, :string
    end

    alter table(:scanners) do
      add :class, :string
    end

    alter table(:xframes) do
      add :class, :string
    end
  end
end
