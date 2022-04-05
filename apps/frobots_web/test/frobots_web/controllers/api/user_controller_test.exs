defmodule FrobotsWeb.Api.UserControllerTest do
  use FrobotsWeb.ConnCase

  import Frobots.AccountsFixtures

  alias Frobots.Accounts.User

  @create_attrs %{
    name: "some name",
    username: "some username"
  }
  @update_attrs %{
    name: "some updated name",
    username: "some updated username"
  }
  @invalid_attrs %{name: nil, username: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "not logged-in" do
    setup [:create_user]

    @tag username: "newaccount@test.me"
    test "requires user authentication on all actions", %{conn: conn, user: user} do
      Enum.each(
        [
          get(conn, Routes.api_user_path(conn, :index)),
          get(conn, Routes.api_user_path(conn, :show, user.id)),
          post(
            conn,
            Routes.api_user_path(conn, :create, user: %{name: "new name", username: "new email"})
          ),
          put(conn, Routes.api_user_path(conn, :update, user.id, user: @update_attrs)),
          delete(conn, Routes.api_user_path(conn, :delete, user.id))
        ],
        fn conn ->
          assert json_response(conn, 401)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    setup [:login]

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

  describe "create user" do
    setup [:login]

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
  end

  describe "update user" do
    # login as admin first, then create the user that we will update
    setup [:login, :create_user]

    @tag login_as: "admin"
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

    @tag login_as: "admin"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.api_user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    @tag login_as: "admin"
    test "make sure admin user and the user being updated are not the same", %{
      conn: conn,
      user: %User{id: id} = user
    } do
      assert conn.assigns.current_user.id != id
      assert conn.assigns.current_user.username == "admin"
      # this is actually the original fixture username
      assert user.username == "some@username.com"
    end
  end

  describe "delete user" do
    setup [:login, :create_user]

    @tag login_as: "admin"
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.api_user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_user_path(conn, :show, user))
      end
    end
  end

  defp create_user(attrs \\ @create_attrs) do
    user = user_fixture(attrs)
    %{user: user}
  end

  defp login(%{conn: conn, login_as: username}) do
    # this creates the user in the db
    user = user_fixture(username: username)
    token = FrobotsWeb.Api.Auth.generate_token(user.username)

    conn =
      conn
      # this assigns to the connection
      |> assign(:current_user, user)
      |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)

    %{conn: conn, user: user}
  end
end
