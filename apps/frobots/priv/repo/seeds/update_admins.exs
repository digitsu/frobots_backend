# Run this in the frobots project
# mix run priv/repo/update_admins.exs

alias Frobots.Accounts

Accounts.update_profile(Accounts.get_user_by(email: "jerry@frobots.io"), %{admin: true})
