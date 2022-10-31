defmodule FrobotsWeb.SendInvites do
  alias FrobotsWeb.{Mailer, BetaMailer, MailTemplates}
  alias Frobots.Accounts

  alias FrobotsWeb.Api.Auth
  alias FrobotsWeb.SendgridApi

  def existing_user?(username) do
    # check database to see if username exists
    params = [username: username]
    Accounts.get_user_by(params)
  end

  # launch_beta will be called from a genserver.
  # when dryrun is true emails will not be sent
  def launch_beta(dryrun) do
    SendgridApi.get_contacts(dryrun)
    |> process_response(dryrun)
  end

  def process_response({:ok, emails}, dryrun) when is_list(emails) do
    send_email(dryrun, emails)
  end

  def process_response({:error, {:status, status_code}}, _dryrun) do
    # write to logger
    IO.inspect(status_code)
  end

  def send_email(dryrun, emails) do
    for email <- emails do
      if existing_user?(email) == nil do
        name = String.split(email, "@") |> Enum.at(0)

        new_user = %{"username" => email, "password" => "Secret!@#", "name" => name}
        {:ok, user} = Accounts.register_user(new_user)
        # get token
        token = Auth.generate_token(user.id)
        # dryrun = true  -- we are testing
        if dryrun == true do
          # just a dry run. No emails are sent.
          IO.puts(email)
        else
          # dryrun = false  -- we are sending emails
          build_mail(user.name, user.username, user.id, token)
          |> Mailer.deliver()
        end
      end
    end
  end

  def build_mail(name, email, uid, token) do
    template =
      MailTemplates.beta_mail_template()
      |> String.replace("#welcome_url", "https://dashboard.frobots.io?id=#{token}&uid=#{uid}")

    BetaMailer.welcome(%{name: name, email: email}, template)
  end
end
