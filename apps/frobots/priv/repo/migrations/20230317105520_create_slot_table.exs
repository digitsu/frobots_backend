defmodule Frobots.Repo.Migrations.CreateSlotTable do
  use Ecto.Migration

  def change do
    create table(:slots) do
      add :frobot_id, references(:frobots, on_delete: :nothing)
      add(:slot_type, :string)
      add(:status, :string)
      add(:match_id, references(:matches, on_delete: :nothing))
    end
  end
end
