defmodule Frobots.Repo.Migrations.AddImageToCannon do
  use Ecto.Migration

  def change do
    alter table(:cannons) do
      add :image_path, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
