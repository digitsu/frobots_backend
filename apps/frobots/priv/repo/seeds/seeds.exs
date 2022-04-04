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
alias Frobots.Repo

Repo.delete_all(Assets.Frobot)
Repo.delete_all(Accounts.User)

{:ok, user} =
  Accounts.register_user(%{
    name: "god",
    username: "god@frobots.io",
    password: "SecretMonkey666"
  })

for {name, brain_path} <- Frobots.frobot_paths() do
  frobot = %{
    "brain_code" => File.read!(brain_path),
    # template
    "class" => "nulla", # I, II, IV, IX, etc
    "name" => ~s/#{name}/,
    "xp" => 0
  }

  Assets.create_frobot!(user, frobot)
end
