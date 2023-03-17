ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Frobots.Repo, :manual)

defmodule FrobotsWeb.TestHelpers do
  import Frobots.AccountsFixtures
  import Frobots.AssetsFixtures
  #  alias FrobotsWeb.UserAuth
  #  alias FrobotsWeb.Api.Auth

  #  alias FrobotsWeb.Guardian

  def create_user(attrs) do
    user = user_fixture(attrs)
    %{user: user}
  end

  def login(%{conn: conn, login_as: email}) do
    {:ok, user} =
      case email do
        "admin" -> user_fixture(email: email, admin: true)
        _ -> user_fixture(email: email)
      end

    conn = Plug.Conn.assign(conn, :current_user, user)
    %{conn: conn, user: user}
  end

  def api_login(%{conn: conn, login_as: email}) do
    # this creates the user in the db
    {:ok, user} =
      case email do
        "admin@mail.com" -> user_fixture(email: email, admin: true)
        _ -> user_fixture(email: email)
      end

    # {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})
    # token = ~s/#{user.name}:#{user.password}/ |> Base.encode64()
    token = FrobotsWeb.Api.Auth.generate_token(user.id)

    conn =
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)

    %{conn: conn, user: user, jwt: token}
  end

  def basic_auth_login(%{conn: conn, login_as: username}) do
    # this creates the user in the db
    password = "supersecret"

    # switch name to email.
    {:ok, user} =
      case username do
        "admin" -> user_fixture(email: username, password: password, admin: true)
        _ -> user_fixture(email: username, password: password)
      end

    token = ~s/#{user.email}:#{password}/ |> Base.encode64()

    conn =
      conn
      # this assigns to the connection
      |> Plug.Conn.assign(:current_user, user)
      |> Plug.Conn.put_req_header("authorization", "Basic " <> token)

    %{conn: conn, user: user}
  end

  def other_user(%{conn: conn, other: email}) do
    user =
      case email do
        "admin" -> user_fixture(email: email, admin: true)
        _ -> user_fixture(email: email)
      end

    %{conn: conn, other: user}
  end

  def create_frobot(%{conn: conn}) do
    frobot = frobot_fixture(conn.assigns.current_user)
    %{conn: conn, frobot: frobot}
  end
end
