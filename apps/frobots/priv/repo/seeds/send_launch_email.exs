alias FrobotsWeb.{BetaMailer, MailTemplates}
alias Frobots.{Accounts, Mailer}
alias FrobotsWeb.SendgridApi

base_url = Application.get_env(:sendgrid, :base_url)
{:ok, emails} = SendgridApi.get_contacts(base_url)

for email <- emails do
  user = Accounts.get_user_by_email(email)
  {:ok, user} =
    if is_nil(user) do
      new_user = %{"email" => email, "password" => "Secret!@#", "name" => email}
      Accounts.register_user(new_user)
    else
      {:ok, user}
    end

  template = MailTemplates.beta_launch_mail_template()
  BetaMailer.welcome(%{name: user.name, email: user.email}, template)
  |> Mailer.deliver()
end
