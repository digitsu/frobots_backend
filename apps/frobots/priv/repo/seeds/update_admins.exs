# Run this in the frobots project
# mix run priv/repo/update_admins.exs

alias Frobots.Accounts

Accounts.update_user(Accounts.get_user_by(username: "jerry@frobots.io"), %{admin: true})