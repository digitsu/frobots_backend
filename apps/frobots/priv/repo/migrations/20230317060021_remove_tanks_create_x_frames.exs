defmodule Frobots.Repo.Migrations.RemoveTanksCreateXFrames do
  use Ecto.Migration

  def change do
    create table(:xframes) do
      add :xframe_type, :string
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

    create unique_index(:xframes, [:xframe_type])

    drop index(:tanks, [:tank_type])
    drop table(:tanks)
  end
end
