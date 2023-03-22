# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Frobots.Repo.insert!(%Frobots.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Frobots.Assets
alias Frobots
alias Frobots.Accounts

admin_user = System.get_env("ADMIN_USER")
admin_pass = System.get_env("ADMIN_PASS")

{:ok, user} =
  Accounts.register_user(%{
    name: "god",
    email: admin_user,
    password: admin_pass
  })

for {name, brain_path} <- Frobots.frobot_paths() do
  type = if name in [:rabbit, :target, :dummy], do: Assets.target_class(), else: Assets.prototype_class() # I, II, IV, IX, etc
  frobot = %{
    "brain_code" => File.read!(brain_path),
    # template
    "class" => type,
    "name" => ~s/#{name}/,
    "xp" => 0
  }

  Assets.create_frobot!(user, frobot)
end

Accounts.update_user(Accounts.get_user_by(email: admin_user), %{admin: true})

Frobots.Assets.create_xframe!(%{
  xframe_type: "Tank_Mk1",
  max_speed_ms: 30,
  turn_speed: 50,
  ## not sure of the values
  scanner_hardpoint: 1,
  weapon_hardpoint: 1,
  movement_type: "tread",
  max_throttle: 100,
  accel_speed_mss: 5,
  max_health: 100
})
