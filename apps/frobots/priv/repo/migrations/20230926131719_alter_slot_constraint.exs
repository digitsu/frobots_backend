defmodule Frobots.Repo.Migrations.AlterSlotConstraint do
  use Ecto.Migration

  def change do
    drop unique_index(:slots, :frobot_id,
           where: "frobot_id IS NOT NULL AND status != 'closed'",
           name: :unique_frobot_id_slot
         )
  end
end
