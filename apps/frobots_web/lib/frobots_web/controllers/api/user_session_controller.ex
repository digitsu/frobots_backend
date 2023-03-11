defmodule FrobotsWeb.Api.UserSessionController do
  use FrobotsWeb, :controller

  alias Frobots.Accounts
  alias Frobots.Accounts.User
  alias FrobotsWeb.Guardian

  def create(conn, %{"email" => nil, "password" => nil}) do
    conn
    |> put_status(401)
    |> put_resp_content_type("application/json")
    |> render("error.json", message: "Email or Password is blank")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      %User{} = user ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        conn
        |> render("create.json", user: user, jwt: jwt)

      nil ->
        conn
        |> put_status(401)
        |> put_resp_content_type("application/json")
        |> render("error.json", message: "User could not be authenticated")
    end
  end
end
