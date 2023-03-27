defmodule Frobots.Repo.Migrations.CreateUniqueIndexInSlotTable do
  use Ecto.Migration

  def change do
    create unique_index(:slots, :frobot_id,
             where: "frobot_id IS NOT NULL AND status != 'closed'",
             name: :unique_frobot_id_slot
           )
  end
end
