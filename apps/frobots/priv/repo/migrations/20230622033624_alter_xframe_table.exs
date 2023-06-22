defmodule Frobots.Repo.Migrations.AlterXframeTable do
  use Ecto.Migration

  def change do
    alter table(:xframes) do
      add :cycletime, :integer, default: 250
      add :cpu_cycle_buffer, :integer, default: 60
      add :overload_penalty, :integer, default: 2_000
    end
  end
end
