defmodule FrobotsWeb.Api.UserSessionControllerTest do
  use FrobotsWeb.ConnCase, async: true

  import Frobots.AccountsFixtures

  setup %{conn: _conn} do
    {:ok, user} = user_fixture()
    %{user: user}
  end

  describe "POST /api/session" do
    test "with no credentials user can't login", %{conn: conn} do
      conn = post(conn, Routes.api_user_session_path(conn, :create), email: nil, password: nil)
      assert %{"message" => "Email or Password is blank"} = json_response(conn, 401)
    end

    test "with invalid password user cant login", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_user_session_path(conn, :create),
          email: user.email,
          password: "wrongpass"
        )

      assert %{"message" => "User could not be authenticated"} = json_response(conn, 401)
    end

    test "with valid password user can login", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.api_user_session_path(conn, :create),
          email: user.email,
          password: dummy_password()
        )

      assert %{
               "data" => %{"token" => "" <> _},
               "message" => "You are successfully logged in" <> _
             } = json_response(conn, 200)
    end
  end
end
