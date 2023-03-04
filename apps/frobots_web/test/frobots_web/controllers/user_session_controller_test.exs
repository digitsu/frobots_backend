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

      assert response =~
               "<button type=\"submit\" class=\"w-full flex\n                            justify-center py-2 px-4 border border-transparent\n                            text-sm font-medium rounded-md text-white\n                            bg-frobots-green-bgc hover:bg-frobots-green-dark\n                            focus:outline-none focus:border-indigo-700\n                            focus:ring-indigo active:bg-frobots-green-dark\n                            transition duration-150 ease-in-out\">\n                Login\n              </button>\n"

      assert response =~ "Create an Account"
      assert response =~ "Forgot your password ?"
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

      assert response =~
               "<button type=\"submit\" class=\"w-full flex\n                            justify-center py-2 px-4 border border-transparent\n                            text-sm font-medium rounded-md text-white\n                            bg-frobots-green-bgc hover:bg-frobots-green-dark\n                            focus:outline-none focus:border-indigo-700\n                            focus:ring-indigo active:bg-frobots-green-dark\n                            transition duration-150 ease-in-out\">\n                Login\n              </button>\n"

      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.user_session_path(conn, :delete))
      assert redirected_to(conn) == "/users/log_in"
      refute get_session(conn, :user_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
