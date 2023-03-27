defmodule Frobots.Repo.Migrations.AddImageToXframe do
  use Ecto.Migration

  def change do
    alter table(:xframes) do
      add :image_path, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
