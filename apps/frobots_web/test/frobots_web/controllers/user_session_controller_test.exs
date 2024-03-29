defmodule FrobotsWeb.UserSessionControllerTest do
  use FrobotsWeb.ConnCase, async: true

  import Frobots.AccountsFixtures

  setup do
    {:ok, user} = user_fixture()
    %{user: user}
  end

  describe "GET /users/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)

      assert response =~ "<h2 class=\"text-3xl leading-9 font-bold text-white\">Login </h2>"
      assert response =~ "New user ?"
      assert response =~ "Create an Account"
      assert response =~ "Enter your email"
      assert response =~ "Enter your password"
      assert response =~ "Remember me"
      assert response =~ "Forgot your password ?"
      assert response =~ "Login"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/log_in" do
    test "logs the user in", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => dummy_password()}
        })

      assert get_session(conn, :user_token)

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/home")
      response = html_response(conn, 200)
      # put this back in when we display the email upon login @djc
      # assert response =~ user.email
      assert response =~ "Garage</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => dummy_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_frobots_web_user_remember_me"]
      assert redirected_to(conn) == "/home"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      conn =
        conn
        |> init_test_session(user_return_to: "/home")
        |> post(
          Routes.user_session_path(conn, :create),
          %{"user" => %{"email" => user.email, "password" => dummy_password()}}
        )

      assert redirected_to(conn) == "/home"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)

      assert response =~ "Login"
      assert response =~ "New user ?"
      assert response =~ "Create an Account"
      assert response =~ "Enter your email"
      assert response =~ "Enter your password"
      assert response =~ "Remember me"
      assert response =~ "Forgot your password ?"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
    end
  end
end
