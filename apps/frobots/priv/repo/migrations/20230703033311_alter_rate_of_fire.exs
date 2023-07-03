defmodule Frobots.Repo.Migrations.AlterRateOfFire do
  use Ecto.Migration

  def change do
    alter table(:cannons) do
      modify :rate_of_fire, :float
    end

    alter table(:cannon_inst) do
      modify :rate_of_fire, :float
    end
  end
end
