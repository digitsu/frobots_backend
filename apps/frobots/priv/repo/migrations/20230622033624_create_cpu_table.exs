defmodule Frobots.Repo.Migrations.CreateCpuTable do
  use Ecto.Migration

  def up do
    create table(:cpus) do
      add :type, :string
      add :cycletime, :integer
      add :cpu_cycle_buffer, :integer
      add :overload_penalty, :integer

      timestamps()
    end

    execute("
      INSERT INTO cpus(type, cycletime, cpu_cycle_buffer, overload_penalty, inserted_at, updated_at)
      VALUES ('Mk1', 60, 250, 2000, NOW(), NOW());
    ")
  end

  def down do
    drop table(:cpus)
  end
end
