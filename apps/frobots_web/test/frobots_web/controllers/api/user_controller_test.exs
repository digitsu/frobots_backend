defmodule FrobotsWeb.Api.UserControllerTest do
  use FrobotsWeb.ConnCase

  alias Frobots.Accounts.User

  @create_attrs %{
    name: "some name",
    username: "some username"
  }
  @update_attrs %{
    name: "some updated name",
    username: "some updated username"
  }
  @update_password_attrs %{
    password: "updated password"
  }

  @invalid_attrs %{name: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Invalid users" do
    setup [:api_login, :other_user]

    @tag login_as: "Jimmy", other: "Bob"
    test "requires admin authentication on all actions", %{conn: conn, other: otheruser} do
      Enum.each(
        [
          # get(conn, Routes.api_user_path(conn, :show, user.id)),
          post(
            conn,
            Routes.api_user_path(conn, :create, user: %{name: "new name", username: "new email"})
          ),
          delete(conn, Routes.api_user_path(conn, :delete, otheruser.id))
        ],
        fn conn ->
          assert json_response(conn, 401)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:api_login]

    @tag login_as: "admin"
    test "lists all users", %{conn: conn, user: user} do
      conn = get(conn, Routes.api_user_path(conn, :index))
      %{id: id, name: name, username: username} = user

      assert [
               %{
                 "id" => ^id,
                 "name" => ^name,
                 "username" => ^username
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "show user" do
    setup [:api_login, :other_user]

    @tag login_as: "Jimmy", other: "Billy"
    test "normal user cannot show details of another user", %{conn: conn, other: user} do
      conn = get(conn, Routes.api_user_path(conn, :show, user.id))
      assert response(conn, 401)
    end

    @tag login_as: "admin", other: "Billy"
    test "Admin user can show details of another user", %{conn: conn, other: user} do
      conn = get(conn, Routes.api_user_path(conn, :show, user.id))
      assert response(conn, 200)
    end
  end

  describe "create user" do
    setup [:api_login]

    @tag login_as: "admin"
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "admin"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag login_as: "Jimmy"
    test "normal user cannot create a user with good inputs", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @create_attrs)
      assert response(conn, 401)
    end

    @tag login_as: "Jimmy"
    test "normal user cannot create a user with bad inputs", %{conn: conn} do
      conn = post(conn, Routes.api_user_path(conn, :create), user: @invalid_attrs)
      assert response(conn, 401)
    end
  end

  describe "update user" do
    # login as admin first, then create the user that we will update
    setup [:api_login, :create_user, :other_user]

    @tag login_as: "admin", other: "Billy"
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "admin", other: "Billy"
    test "renders errors when data is invalid", %{conn: conn, other: user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag login_as: "admin", other: "Billy"
    test "make sure admin user and the user being updated are not the same", %{
      conn: conn,
      user: %User{id: id} = user
    } do
      assert conn.assigns.current_user.id != id
      assert conn.assigns.current_user.username == "admin"
      # this is actually the original fixture username
      assert user.username == "some@username.com"
    end

    @tag login_as: "Jimmy", other: "Billy"
    test "One user cannot change the details of another user", %{conn: conn, other: user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @update_attrs)
      assert response(conn, 401)
    end

    @tag login_as: "Jimmy", other: "Jimmy"
    test "User changes their OWN password", %{conn: conn, other: %User{id: id} = user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @update_password_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               # when you update your user data, you just get name and username back
               "name" => "Jimmy",
               "username" => "Jimmy"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete user" do
    setup [:api_login, :other_user]

    @tag login_as: "admin", other: "Billy"
    test "admin deletes chosen user", %{conn: conn, other: user} do
      conn = delete(conn, Routes.api_user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_user_path(conn, :show, user))
      end
    end

    @tag login_as: "Jimmy", other: "Billy"
    test "One user can't delete another user", %{conn: conn, other: user} do
      conn = delete(conn, Routes.api_user_path(conn, :delete, user))
      assert response(conn, 401)
    end
  end
end
