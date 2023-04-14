defmodule Frobots.Repo.Migrations.AlterSlotTableForFrobotConstraint do
  use Ecto.Migration

  def up do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)

    alter table(:slots) do
      add :match_type, :string
    end

    execute "update slots set match_type = 'simulation';"

    create unique_index(:slots, :frobot_id,
             where:
               "frobot_id IS NOT NULL AND match_type = 'real' And status != 'closed' AND status != 'done' AND slot_type != 'protobot'",
             name: :unique_frobot_id_slot
           )
  end

  def down do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)

    alter table(:slots) do
      remove :match_type, :string
    end

    create unique_index(:slots, :frobot_id,
             where:
               "frobot_id IS NOT NULL AND status != 'closed' AND status != 'done' AND slot_type != 'protobot'",
             name: :unique_frobot_id_slot
           )
  end
end
