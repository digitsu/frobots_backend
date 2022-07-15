ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Frobots.Repo, :manual)

defmodule FrobotsWeb.TestHelpers do
  import Frobots.AccountsFixtures
  import Frobots.AssetsFixtures

  def create_user(attrs) do
    user = user_fixture(attrs)
    %{user: user}
  end

  def login(%{conn: conn, login_as: username}) do
    user =
      case username do
        "admin" -> user_fixture(username: username, admin: true)
        _ -> user_fixture(username: username)
      end

    conn = Plug.Conn.assign(conn, :current_user, user)
    %{conn: conn, user: user}
  end

  def api_login(%{conn: conn, login_as: username}) do
    # this creates the user in the db
    user =
      case username do
        "admin" -> user_fixture(username: username, admin: true)
        _ -> user_fixture(username: username)
      end

    token = FrobotsWeb.Api.Auth.generate_token(user.username)

    conn =
      conn
      # this assigns to the connection
      |> Plug.Conn.assign(:current_user, user)
      |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)

    %{conn: conn, user: user}
  end

  def create_frobot(%{conn: conn}) do
    frobot = frobot_fixture(conn.assigns.current_user)
    %{conn: conn, frobot: frobot}
  end
end
