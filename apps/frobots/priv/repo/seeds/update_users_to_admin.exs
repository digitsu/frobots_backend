alias Frobots.Accounts

emails = ["sumit@frobots.io", "gok@dataequinox.com", "jishnu@dataequinox.com", "hari@dataequinox.com"]
for email <- emails do
  case Accounts.get_user_by_email(email) do
    nil -> :ok
    user -> Accounts.update_profile(user, %{admin: true})
  end
end
