defmodule Frobots.Repo.Migrations.AddImageToScanner do
  use Ecto.Migration

  def change do
    alter table(:scanners) do
      add :image_path, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
