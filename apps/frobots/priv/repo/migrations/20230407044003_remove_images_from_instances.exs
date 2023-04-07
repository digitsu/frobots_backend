defmodule Frobots.Repo.Migrations.RemoveImagesFromInstances do
  use Ecto.Migration

  def up do
    alter table(:xframe_inst) do
      remove :image, :string
    end

    alter table(:cannon_inst) do
      remove :image, :string
    end

    alter table(:missile_inst) do
      remove :image, :string
    end

    alter table(:scanner_inst) do
      remove :image, :string
    end
  end

  def down do
    alter table(:xframe_inst) do
      add :image, :string
    end

    alter table(:cannon_inst) do
      add :image, :string
    end

    alter table(:missile_inst) do
      add :image, :string
    end

    alter table(:scanner_inst) do
      add :image, :string
    end
  end
end
