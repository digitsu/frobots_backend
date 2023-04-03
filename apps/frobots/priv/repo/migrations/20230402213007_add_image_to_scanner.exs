defmodule Frobots.Repo.Migrations.AddImageToScanner do
  use Ecto.Migration

  def up do
    alter table(:scanners) do
      add :image, :string
    end

    alter table(:scanner_inst) do
      add :image, :string
    end
  end

  def down do
    alter table(:scanners) do
      remove :image, :string
    end

    alter table(:scanner_inst) do
      remove :image, :string
    end
  end
end
