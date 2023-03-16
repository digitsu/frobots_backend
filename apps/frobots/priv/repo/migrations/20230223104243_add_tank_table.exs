defmodule Frobots.Repo.Migrations.AddTankTable do
  use Ecto.Migration

  def change do
    create table(:tanks) do
      add :tank_type, :string
      add :max_speed_ms, :integer
      add :turn_speed, :integer
      add :scanner_hardpoint, :integer
      add :weapon_hardpoint, :integer
      add :movement_type, :string
      add :max_health, :integer
      add :max_throttle, :integer
      add :accel_speed_mss, :integer

      timestamps()
    end

    create unique_index(:tanks, [:tank_type])
  end
end
