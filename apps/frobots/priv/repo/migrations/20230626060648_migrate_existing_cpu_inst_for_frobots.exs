defmodule Frobots.Repo.Migrations.MigrateExistingCpuInstForFrobots do
  use Ecto.Migration

  def up do
    create_if_not_exists unique_index(:cpu_inst, [:frobot_id])
    cpu = Frobots.Assets.get_cpu!(:Mk1)

    Frobots.Assets.list_frobots()
    |> Enum.each(fn frobot ->
      params = %{
        user_id: frobot.user_id,
        cpu_id: cpu.id,
        frobot_id: frobot.id,
        cycletime: cpu.cycletime,
        cpu_cycle_buffer: cpu.cpu_cycle_buffer,
        overload_penalty: cpu.overload_penalty
      }

      %Frobots.Assets.CpuInst{}
      |> Frobots.Assets.CpuInst.changeset(params)
      |> Frobots.Repo.insert!()
    end)
  end

  def down do
    drop_if_exists unique_index(:cpu_inst, [:frobot_id])
  end
end
