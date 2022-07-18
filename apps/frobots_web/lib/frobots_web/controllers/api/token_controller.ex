defmodule FrobotsWeb.Api.TokenController do
  use FrobotsWeb, :controller

  action_fallback FrobotsWeb.FallbackController

  def gen_token(conn, _params) do
    case Map.get(conn.assigns, :current_user, nil) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(FrobotsWeb.ErrorView)
        |> render(:"401")
        # Stop any downstream transformations.
        |> halt()

      %Frobots.Accounts.User{} = user ->
        render(conn, "show.json", token: FrobotsWeb.Api.Auth.generate_token(user.id))
    end
  end
end
