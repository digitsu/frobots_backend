# Run this in the frobots project
# mix run priv/repo/update_admins.exs

alias Frobots.Accounts
{:ok, user} =
  Accounts.register_user(%{
    name: System.get_env("LOCAL_USER"),
    email: System.get_env("LOCAL_USER_EMAIL"),
    password: System.get_env("LOCAL_USER_PASS"),
    admin: true
  })

