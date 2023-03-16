defmodule Frobots.Repo.Migrations.CreateMissile do
  use Ecto.Migration

  def change do
    create table(:missiles) do
      add :missile_type, :string
      add :damage_direct, {:array, :integer}
      add :damage_near, {:array, :integer}
      add :damage_far, {:array, :integer}
      add :speed, :integer
      add :range, :integer
      timestamps()
    end
  end
end
