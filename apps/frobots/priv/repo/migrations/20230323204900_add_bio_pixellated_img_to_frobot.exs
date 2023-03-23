defmodule Frobots.Repo.Migrations.AddBioPixellatedImgToFrobot do
  use Ecto.Migration

  def change do
    alter table(:frobots) do
      add :pixellated_img, :string, default: "https://via.placeholder.com/50.png"
      add :bio, :string
    end
  end
end
