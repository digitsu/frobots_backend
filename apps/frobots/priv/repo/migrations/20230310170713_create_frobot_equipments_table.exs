defmodule Frobots.Repo.Migrations.CreateFrobotEquipmentsTable do
  use Ecto.Migration

  def change do
    create table(:equipment) do
      add :equipment_id, :integer
      add :equipment_type, :string
      add :frobot_id, references(:frobots, on_delete: :nothing)
      timestamps()
    end
  end
end
