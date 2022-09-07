defmodule FrobotsWeb.SendInvites do
  alias FrobotsWeb.{Mailer, BetaMailer, MailTemplates}
  alias Frobots.Accounts

  alias FrobotsWeb.Api.Auth

  # @filepath Path.join([:code.priv_dir(:frobots_web), "csv", "beta-emails.csv"])
  # @dryrunpath Path.join([:code.priv_dir(:frobots_web), "csv", "dryrun.csv"])

  def launch_beta() do
    # parse csv file
    File.read!(Path.join([:code.priv_dir(:frobots_web), "csv", "beta-emails.csv"]))
    |> String.split("\n")
    |> Enum.map(fn x ->
      # remove quotes
      x = String.replace(x, "\"", "")
      fields = String.split(x, ",")
      field = Enum.at(fields, 0)

      name = String.split(field, "@") |> Enum.at(0)

      # insert user
      new_user = %{"username" => field, "password" => "Secret!@#", "name" => name}
      {:ok, user} = Accounts.register_user(new_user)

      # # get token
      token = Auth.generate_token(user.id)

      build_mail(user.name, user.username, user.id, token)
      |> Mailer.deliver()
    end)
  end

  def dry_run_beta() do
    # parse csv file
    File.read!(Path.join([:code.priv_dir(:frobots_web), "csv", "dryrun.csv"]))
    |> String.split("\n")
    |> Enum.map(fn x ->
      x = String.replace(x, "\"", "")
      fields = String.split(x, ",")
      field = Enum.at(fields, 0)

      name = String.split(field, "@") |> Enum.at(0)

      new_user = %{"username" => field, "password" => "Secret!@#", "name" => name}

      {:ok, user} = Accounts.register_user(new_user)
      IO.inspect(user)
      # # get token
      token = Auth.generate_token(user.id)

      build_mail(user.name, user.username, user.id, token)
      |> Mailer.deliver()
    end)
  end

  def build_mail(name, email, uid, token) do
    template =
      MailTemplates.beta_mail_template()
      |> String.replace("#welcome_url", "https://frobots.io?token=#{token}&uid=#{uid}")

    BetaMailer.welcome(%{name: name, email: email}, template)
  end
end
