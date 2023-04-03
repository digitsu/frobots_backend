defmodule Frobots.Repo.Migrations.ConvertXframeMovementTypeBipedal do
  use Ecto.Migration

  def up do
    execute "update xframes set movement_type = 'bipedal' where type = 'Tank_Mk1' or type = 'Tank_Mk2' or type = 'Tank_Mk3'"
    execute "update xframes set type = 'Chassis_Mk1' where type = 'Tank_Mk1'"
    execute "update xframes set type = 'Chassis_Mk2' where type = 'Tank_Mk2'"
    execute "update xframes set type = 'Chassis_Mk3' where type = 'Tank_Mk3'"
  end
  def down do
    IO.inspect("nothing to rollback")
  end
end
