defmodule FrobotsWeb.Api.TokenView do
  use FrobotsWeb, :view
  alias FrobotsWeb.Api.TokenView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, TokenView, "token.json")}
  end

  def render("token.json", %{token: user}) do
    %{
      token: FrobotsWeb.Api.Auth.generate_token(user.id),
      user_id: user.id
    }
  end
end
