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
               "<div class=\"mt-6\">\n            <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc text-white border\n                border-gray-600 rounded py-3 px-4 leading-tight\n                focus:outline-none focus:bg-frobots-login-in-bgc-light\n                focus:border-green-300\" id=\"user_email\" name=\"user[email]\" placeholder=\"Enter your email\" type=\"email\" value=\"some@username.com\">\n            </div>\n\n          </div>\n\n\n          <div class=\"mt-6\">\n            <div class=\"mt-1 rounded-md shadow-sm\">\n<input class=\"w-full block bg-frobots-login-in-bgc\n                    text-white border border-gray-600 rounded py-3 px-4\n                    leading-tight focus:outline-none\n                    focus:bg-frobots-login-in-bgc-light focus:border-green-300\" id=\"user_password\" name=\"user[password]\" placeholder=\"Enter your\n                    password\" type=\"password\">\n            </div>\n\n          </div>\n\n          <div class=\"mt-6 flex items-center justify-between\">\n            <div class=\"flex items-center\">\n<input name=\"user[persistent_session]\" type=\"hidden\" value=\"false\"><input class=\"form-checkbox\n                        h-4 w-4 text-indigo-600 transition duration-150\n                        ease-in-out\" id=\"user_persistent_session\" name=\"user[persistent_session]\" type=\"checkbox\" value=\"true\">\n<label class=\"ml-2 block text-sm leading-5 text-white\" for=\"user_persistent_session\">Remember me</label>\n            </div>\n\n            <div class=\"text-sm leading-5\">\n              <a href=\"/users/reset_password\" class=\"font-medium text-frobots-green\n                            hover:text-frobots-green-dark focus:outline-none\n                            focus:underline transition ease-in-out\n                            duration-150\">\n                Forgot your password ?\n              </a>\n            </div>\n          </div>\n\n          <div class=\"mt-6\">\n            <span class=\"block w-full rounded-md shadow-sm\">\n              <button type=\"submit\" class=\"w-full flex\n                            justify-center py-2 px-4 border border-transparent\n                            text-sm font-medium rounded-md text-white\n                            bg-frobots-green-bgc hover:bg-frobots-green-dark\n                            focus:outline-none focus:border-indigo-700\n                            focus:ring-indigo active:bg-frobots-green-dark\n                            transition duration-150 ease-in-out\">\n                Login\n              </button>\n            </span>\n          </div>\n\n            <div x-show.transition.opacity=\"fade\" class=\"py-4\">\n              <p class=\"alert alert-danger m-auto\" role=\"alert\">\nInvalid email or password\n              </p>\n            </div>"

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
