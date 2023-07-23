alias FrobotsWeb.{BetaMailer, MailTemplates}
alias Frobots.{Accounts, Mailer}
alias FrobotsWeb.SendgridApi

filename = Application.get_env(:frobots_web, :beta_email_list)
file_path = Path.join([:code.priv_dir(:frobots_web), "csv", filename ])
emails = File.read!(file_path)
  |> String.split(",", trim: true)
  |> Enum.filter(fn x -> String.contains?(x, "@") end)
  |> Enum.map( fn x -> Regex.split(~r{\n}, x) end)
  |> Enum.into( [], fn [_, email] -> email end)
  |> Enum.map( fn x -> String.replace(x, "\"", "") end)
IO.puts "Going to send mails to this list\n"
IO.inspect emails
# base_url = Application.get_env(:sendgrid, :base_url)
# {:ok, emails} = SendgridApi.get_contacts(base_url)

for email <- emails do
  user = Accounts.get_user_by_email(email)
  {:ok, user} =
    if is_nil(user) do
      new_user = %{"email" => email, "password" => "Secret!@#", "name" => email}
      Accounts.register_user(new_user)
    else
      {:ok, user}
    end
  IO.puts "Sending mail to #{user.email}"
  template = MailTemplates.beta_launch_mail_template()
  BetaMailer.welcome(%{name: user.name, email: user.email}, template)
  |> Mailer.deliver()
end
