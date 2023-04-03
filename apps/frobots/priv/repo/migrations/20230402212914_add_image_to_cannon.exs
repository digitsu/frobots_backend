defmodule Frobots.Repo.Migrations.AddImageToCannon do
  use Ecto.Migration

  def up do
    alter table(:cannons) do
      add :image, :string
    end

    alter table(:cannon_inst) do
      add :image, :string
    end
  end

  def down do
    alter table(:cannons) do
      remove :image, :string
    end

    alter table(:cannon_inst) do
      remove :image, :string
    end
  end
end
