defmodule FrobotsWeb.BetaMailer do
  import Swoosh.Email

  def welcome(user, template) do
    new()
    |> to({user.name, user.email})
    |> from({"Frobots", "support@frobots.io"})
    |> subject("Hello, Gamers!")
    |> html_body(template)
    |> text_body("Hello #{user.name}\n")
  end
end
