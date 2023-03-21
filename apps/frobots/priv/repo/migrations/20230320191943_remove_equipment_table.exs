defmodule Frobots.Repo.Migrations.RemoveEquipmentTable do
  use Ecto.Migration

  def up do
    drop_if_exists table(:equipment)

    create_if_not_exists table(:xframe_inst) do
      add :xframe_id, references(:xframes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nilify_all)
      add :frobot_id, references(:frobots, on_delete: :nilify_all)

      add :max_speed_ms, :integer
      add :turn_speed, :integer
      add :scanner_hardpoint, :integer
      add :weapon_hardpoint, :integer
      add :max_health, :integer
      add :max_throttle, :integer
      add :accel_speed_mss, :integer
      # persisted state
      add :health, :integer
      timestamps()
    end
    create_if_not_exists index(:xframe_inst, [:user_id])

    create_if_not_exists table(:cannon_inst) do
      add :cannon_id, references(:cannons, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nilify_all)
      add :frobot_id, references(:frobots, on_delete: :nilify_all)

      add :reload_time, :integer
      add :rate_of_fire, :integer
      add :magazine_size, :integer
      timestamps()
    end
    create_if_not_exists index(:cannon_inst, [:user_id])

    create_if_not_exists table(:scanner_inst) do
      add :scanner_id, references(:scanners, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nilify_all)
      add :frobot_id, references(:frobots, on_delete: :nilify_all)

      add :max_range, :integer
      add :resolution, :integer
      timestamps()
    end
    create_if_not_exists index(:scanner_inst, [:user_id])

    create_if_not_exists table(:missile_inst) do
      add :missile_id, references(:missiles, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nilify_all)
      add :frobot_id, references(:frobots, on_delete: :nilify_all)

      add :damage_direct, {:array, :integer}
      add :damage_near, {:array, :integer}
      add :damage_far, {:array, :integer}
      add :speed, :integer
      add :range, :integer
      timestamps()
    end
    create_if_not_exists index(:missile_inst, [:user_id])
  end

  def down do
    create_if_not_exists table(:equipment) do
      add :equipment_id, :integer
      add :equipment_type, :string
      add :frobot_id, references(:frobots, on_delete: :nothing)
      timestamps()
    end
    drop index(:xframe_inst, [:user_id])
    drop table(:xframe_inst)
    drop index(:cannon_inst, [:user_id])
    drop table(:cannon_inst)
    drop index(:scanner_inst, [:user_id])
    drop table(:scanner_inst)
    drop index(:missile_inst, [:user_id])
    drop table(:missile_inst)
  end
end
