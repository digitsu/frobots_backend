defmodule FrobotsWeb.UserControllerTest do
  use FrobotsWeb.ConnCase

  @create_attrs %{
    name: "some name",
    username: "some username",
    password: "somesecret",
    admin: false
  }
  @update_attrs %{
    name: "some updated name",
    username: "some updated username"
  }
  @invalid_attrs %{name: nil, username: nil}

  describe "not logged-in" do
    setup [:create_user]

    @tag username: "newaccount@test.me"
    test "requires user authentication on all but new/create actions", %{
      conn: conn,
      user: user
    } do
      # currently these are allowed even without login. Because otherwise there is no way to create users!
      Enum.each(
        [
          # put a request here that is allowed without a login.
        ],
        fn conn ->
          assert html_response(conn, 200)
          refute conn.halted
        end
      )

      # these are not allowed if not logged in, controller should redirect, show a flash, and halt connection processing
      Enum.each(
        [
          get(conn, Routes.user_path(conn, :index)),
          get(conn, Routes.user_path(conn, :show, user.id)),
          get(conn, Routes.user_path(conn, :edit, user.id, user: @update_attrs)),
          put(conn, Routes.user_path(conn, :update, user.id, user: @update_attrs)),
          delete(conn, Routes.user_path(conn, :delete, user.id)),
          post(
            conn,
            Routes.user_path(conn, :create, user: %{name: "new name", username: "new email"})
          ),
          get(conn, Routes.user_path(conn, :new))
        ],
        fn conn ->
          assert IO.inspect(html_response(conn, 302))
          assert conn.halted
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

  describe "new user from unauthorized login" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "create user" do
    setup [:login]

    @tag login_as: "admin"
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert html_response(conn, 302) =~ "redirected"
    end

    @tag login_as: "admin"
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

    @tag login_as: "biggs"
    test "redirects to show updated user when data is valid", %{conn: conn, user: user} do
      updated_conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(updated_conn) == Routes.user_path(updated_conn, :show, user)
      # note: we shouldn't allow edits to the username... as this changes how they log in, but maybe it may work.
      assert html_response(updated_conn, 302) =~ "redirected"
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
end
