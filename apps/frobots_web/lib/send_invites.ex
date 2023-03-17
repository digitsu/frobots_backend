defmodule FrobotsWeb.SendInvites do
  alias FrobotsWeb.{BetaMailer, MailTemplates}
  alias Frobots.{Accounts, Mailer}
  alias FrobotsWeb.SendgridApi
  require Logger

  def existing_user?(email) do
    # check database to see if username exists
    Accounts.get_user_by_email(email)
  end

  def process_mailing_list() do
    base_url = Application.get_env(:sendgrid, :base_url)
    # passing base_url as parameter so that we can substitute a test url during tests
    SendgridApi.get_contacts(base_url)
    |> process_response()
  end

  def process_response({:ok, emails}) when is_list(emails) do
    send_email(emails)
    {:ok, "Emails sent"}
  end

  def process_response({:error, {:status, status_code}}) do
    Logger.error("There was an error sending email: Code #{status_code}")
    {:error, {:status, status_code}}
  end

  def send_email(emails) do
    for email <- emails do
      if existing_user?(email) == nil do
        new_user = %{"username" => email, "password" => "Secret!@#", "name" => email}
        {:ok, user} = Accounts.register_user(new_user)
        # get token
        token = generate_token(user.id)

        build_mail(user.name, user.username, user.id, token)
        |> Mailer.deliver()
      end
    end
  end

  def build_mail(name, email, uid, token) do
    template =
      MailTemplates.beta_mail_template()
      |> String.replace("#welcome_url", "https://dashboard.frobots.io?id=#{token}&uid=#{uid}")

    BetaMailer.welcome(%{name: name, email: email}, template)
  end

  def generate_token(user_id) do
    Phoenix.Token.sign(
      FrobotsWeb.Endpoint,
      inspect(__MODULE__),
      user_id
    )
  end
end
