defmodule FrobotsWeb.UsersLiveTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  #  alias FrobotsWeb.ConnCase

  use ExUnit.Case, async: true

  describe "user is not logged in" do
    test "/live should redirect to /users/log_in if user is not logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log_in"}}} =
               live(conn, Routes.users_index_path(conn, :index))
    end
  end

  describe "user is logged in" do
    setup [:create_user, :register_and_log_in_user]
    # assert html has certain elements
    test "/live should display list of users", %{conn: conn, user: user} do
      {:ok, user_live, html} = live(conn, Routes.users_index_path(conn, :index))

      assert has_element?(user_live, "table")
      assert html =~ "Users"
      assert html =~ user.email
    end

    test "admin can create new user with valid attributes", %{conn: conn} do
      {:ok, user_live, _html} = live(conn, Routes.users_index_path(conn, :index))

      # Click on New Item
      user_live
      |> element("#new_user_btn a", "New User")
      |> render_click()

      # assert path
      assert_patched(user_live, "/users/new")

      # assert there is form object with name, email and password
      {:ok, _view, html} =
        user_live
        |> form("#user-form",
          user: %{
            name: "awesomejoe",
            email: get_unique_email(),
            password: get_valid_password()
          }
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.users_index_path(conn, :index))

      assert html =~ "awesomejoe"
    end
  end
end
