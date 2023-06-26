defmodule Frobots.Repo.Migrations.CreateCpuInstTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:cpu_inst) do
      add :cpu_id, references(:cpus, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nilify_all)
      add :frobot_id, references(:frobots, on_delete: :nilify_all)

      add :cycletime, :integer
      add :cpu_cycle_buffer, :integer
      add :overload_penalty, :integer

      timestamps()
    end
  end
end
