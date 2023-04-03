defmodule Frobots.Repo.Migrations.AddImageToMissile do
  use Ecto.Migration

  def up do
    alter table(:missiles) do
      add :image, :string
    end

    alter table(:missile_inst) do
      add :image, :string
    end
  end

  def down do
    alter table(:missiles) do
      remove :image, :string
    end

    alter table(:missile_inst) do
      remove :image, :string
    end
  end
end
