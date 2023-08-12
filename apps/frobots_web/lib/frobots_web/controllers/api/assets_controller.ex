defmodule FrobotsWeb.Api.AssetsController do
  use FrobotsWeb, :controller
  alias Frobots.Assets

  action_fallback FrobotsWeb.FallbackController

  def index(conn, _params) do
    entries = Assets.user_classes()
    conn
    |> put_status(200)
    |> json(entries)
  end
end
