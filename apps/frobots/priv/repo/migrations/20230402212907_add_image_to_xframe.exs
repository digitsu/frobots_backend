defmodule Frobots.Repo.Migrations.AddImageToXframe do
  use Ecto.Migration

  def up do
    alter table(:xframes) do
      add :image, :string
    end

    alter table(:xframe_inst) do
      add :image, :string
    end
  end

  def down do
    alter table(:xframes) do
      remove :image, :string
    end

    alter table(:xframe_inst) do
      remove :image, :string
    end
  end
end
