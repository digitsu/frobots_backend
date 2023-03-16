defmodule :"Elixir.Frobots.Repo.Migrations.AddAvatarToFrobots" do
  use Ecto.Migration

  def change do
    alter table(:frobots) do
      add :avatar, :string, default: "https://via.placeholder.com/50.png"
    end
  end
end
