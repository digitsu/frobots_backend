defmodule FrobotsWeb.UserControllerTest do
  use FrobotsWeb.ConnCase

  import Frobots.AccountsFixtures

  @create_attrs %{name: "some name", username: "some username", password: "somesecret"}
  @update_attrs %{
    name: "some updated name",
    username: "some updated username"
  }
  @invalid_attrs %{name: nil, username: nil}

  describe "not logged-in" do
    setup [:create_user]

    test "requires user authentication on all actions", %{conn: conn, user_id: user_id} do
      Enum.each(
        [
          get(conn, Routes.user_path(conn, :new)),
          get(conn, Routes.user_path(conn, :edit, user_id, user: @update_attrs)),
          post(
            conn,
            Routes.user_path(conn, :create, user: %{name: "new name", username: "new email"})
          )
        ],
        fn conn ->
          assert html_response(conn, 200)
        end
      )

      Enum.each(
        [
          get(conn, Routes.user_path(conn, :index)),
          get(conn, Routes.user_path(conn, :show, user_id)),
          put(conn, Routes.user_path(conn, :update, user_id, user: @update_attrs)),
          delete(conn, Routes.user_path(conn, :delete, user_id))
        ],
        fn conn ->
          assert html_response(conn, 302)
          # assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:login]

    @tag login_as: "admin"
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      id = get_session(conn, :user_id)
      assert redirected_to(conn) == Routes.user_path(conn, :index)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:login]

    @tag login_as: "admin"
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:login]

    @tag login_as: "admin"
    test "redirects when data is valid", %{conn: conn, user: user} do
      updated_conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(updated_conn) == Routes.user_path(updated_conn, :show, user)
      # assert html_response(updated_conn, 200)
      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated username"
    end

    @tag login_as: "admin"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:login]

    @tag login_as: "admin"
    test "deletes chosen user", %{conn: conn, user: user} do
      delete_conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(delete_conn) == Routes.user_path(delete_conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(%{conn: conn}) do
    {:ok, user} =
      %{}
      |> Enum.into(%{
        name: "singleton",
        username: "singleton@user.com",
        password: "supersecretmega"
      })
      |> Frobots.Accounts.register_user()

    # return a copy with the password nilified
    Map.put(user, :password, nil)
    %{conn: conn, user_id: user.id}
  end

  defp login(%{conn: conn, login_as: username}) do
    user = user_fixture(username: username)
    conn = assign(conn, :current_user, user)
    %{conn: conn, user: user}
  end
end
