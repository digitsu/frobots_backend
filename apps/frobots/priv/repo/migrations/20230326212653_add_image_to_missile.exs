defmodule Frobots.Repo.Migrations.AddImageToMissile do
  use Ecto.Migration

  def change do
    alter table(:missiles) do
      add :image_path, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
