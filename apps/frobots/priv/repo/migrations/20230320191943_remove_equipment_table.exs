defmodule Frobots.Repo.Migrations.RemoveEquipmentTable do
  use Ecto.Migration

  def change do
    drop table(:equipment)
    create table(:xframe_inst) do
      add :xframe_id, references(:xframes, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nilify_all)
      add :frobot_id, references(:frobot, on_delete: :nilify_all)

      add :max_speed_ms, :integer
      add :turn_speed, :integer
      add :scanner_hardpoint, :integer
      add :weapon_hardpoint, :integer
      add :max_health, :integer
      add :max_throttle, :integer
      add :accel_speed_mss, :integer
      #persisted state
      add :health, :integer
      timestamps()
    end
    create table(:cannon_inst) do
      add :cannon_id, references(:cannons, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nilify_all)
      add :frobot_id, references(:frobot, on_delete: :nilify_all)

      add :reload_time, :integer
      add :rate_of_fire, :integer
      add :magazine_size, :integer
      timestamps()
    end
    create table(:scanner_inst) do
      add :scanner_id, references(:scanners, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nilify_all)
      add :frobot_id, references(:frobot, on_delete: :nilify_all)

      add :max_range, :integer
      add :resolution, :integer
      timestamps()
    end
    create table(:missile_inst) do
      add :missile_id, references(:missiles, on_delete: :nothing)
      add :user_id, references(:user, on_delete: :nilify_all)
      add :frobot_id, references(:frobot, on_delete: :nilify_all)

      add :damage_direct, {:array, :integer}
      add :damage_near, {:array, :integer}
      add :damage_far, {:array, :integer}
      add :speed, :integer
      add :range, :integer
      timestamps()
    end
  end
end
