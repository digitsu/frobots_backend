defmodule FrobotsWeb.BetaMailer do
  @moduledoc """
  The BetaMailer context.
  """
  import Swoosh.Email

  def welcome(user, template) do
    new()
    |> to({user.name, user.email})
    |> from({"FROBOTs", "support@frobots.io"})
    |> subject("Hello, Gamers!")
    |> html_body(template)
    |> text_body("Hello #{user.name}\n")
  end
end
