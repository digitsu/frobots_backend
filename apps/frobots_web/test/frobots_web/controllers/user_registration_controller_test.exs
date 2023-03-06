defmodule FrobotsWeb.UserRegistrationControllerTest do
  use FrobotsWeb.ConnCase, async: true

  import Frobots.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      {:ok, user} = user_fixture()
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)

      assert response =~ "Register"
      assert response =~ "Enter your email"
      assert response =~ "Enter your password"
      assert response =~ "Register to Frobots"

      assert response =~
               "Already have an account ? Login"

      assert response =~ "Forgot your password?"
    end

    test "redirects if already logged in", %{conn: conn} do
      {:ok, user} = user_fixture()
      conn = conn |> log_in_user(user) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/home"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Garage</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "short"}
        })

      response = html_response(conn, 200)

      assert response =~
               "Already have an account ? Login"
    end
  end
end
