defmodule FrobotsWeb.Api.TokenView do
  use FrobotsWeb, :view
  alias FrobotsWeb.Api.TokenView

  def render("show.json", %{token: token}) do
    %{data: render_one(token, TokenView, "token.json")}
  end

  def render("token.json", %{token: token}) do
    %{
      token: token
    }
  end
end
