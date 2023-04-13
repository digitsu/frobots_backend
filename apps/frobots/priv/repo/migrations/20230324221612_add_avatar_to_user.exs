defmodule Frobots.Repo.Migrations.AddAvatarToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :avatar, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
