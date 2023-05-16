defmodule Frobots.Repo.Migrations.UpdateFrobotConstraint do
  use Ecto.Migration

  def up do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)
    create unique_index(:slots, :frobot_id,
             where:
               "frobot_id IS NOT NULL AND match_type = 'real' And status != 'closed' AND status != 'done' AND status != 'cancelled' AND slot_type != 'protobot'",
             name: :unique_frobot_id_slot
           )
  end

  def down do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)
    create unique_index(:slots, :frobot_id,
             where:
               "frobot_id IS NOT NULL AND match_type = 'real' And status != 'closed' AND status != 'done' AND status != 'cancelled' AND slot_type != 'protobot'",
             name: :unique_frobot_id_slot
           )

  end
end
