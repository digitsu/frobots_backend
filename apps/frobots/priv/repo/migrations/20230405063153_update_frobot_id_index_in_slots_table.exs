defmodule Frobots.Repo.Migrations.UpdateFrobotIdIndexInSlotsTable do
  use Ecto.Migration

  def up do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)

    create unique_index(:slots, :frobot_id,
             where:
               "frobot_id IS NOT NULL AND status != 'closed' AND status != 'done' AND slot_type != 'protobot'",
             name: :unique_frobot_id_slot
           )
  end

  def down do
    drop index(:slots, :frobot_id, name: :unique_frobot_id_slot)

    create unique_index(:slots, :frobot_id,
             where: "frobot_id IS NOT NULL AND status != 'closed' AND status != 'done'",
             name: :unique_frobot_id_slot
           )
  end
end
