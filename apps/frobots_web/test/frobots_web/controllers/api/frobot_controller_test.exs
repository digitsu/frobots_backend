defmodule FrobotsWeb.Api.FrobotControllerTest do
  use FrobotsWeb.ConnCase, async: true

  import Frobots.AssetsFixtures

  alias Frobots.Assets.Frobot

  @create_attrs %{
    brain_code: "some brain_code",
    class: "some class",
    name: "some name",
    xp: 42
  }
  @update_attrs %{
    brain_code: "some updated brain_code",
    class: "some updated class",
    name: "some updated name",
    xp: 43
  }
  @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.api_frobot_path(conn, :index)),
        get(conn, Routes.api_frobot_path(conn, :show, "123")),
        put(conn, Routes.api_frobot_path(conn, :update, "123", %{})),
        post(conn, Routes.api_frobot_path(conn, :create, %{})),
        delete(conn, Routes.api_frobot_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert json_response(conn, 401)
        assert conn.halted
      end
    )
  end

  describe "index" do
    setup [:login]
    @tag login_as: "god"
    test "lists all frobots", %{conn: conn} do
      conn = get(conn, Routes.api_frobot_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create frobot" do
    setup [:login]

    @tag login_as: "god"
    test "renders frobot when data is valid", %{conn: conn} do
      create_conn = post(conn, Routes.api_frobot_path(conn, :create), frobot: @create_attrs)
      assert %{"id" => id} = json_response(create_conn, 201)["data"]

      conn = get(conn, Routes.api_frobot_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brain_code" => "some brain_code",
               "class" => "some class",
               "name" => "some name",
               "xp" => 42
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "god"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_frobot_path(conn, :create), frobot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update frobot" do
    setup [:login, :create_frobot]

    @tag login_as: "god"
    test "renders frobot when data is valid", %{conn: conn, frobot: %Frobot{id: id} = frobot} do
      update_conn = put(conn, Routes.api_frobot_path(conn, :update, frobot), frobot: @update_attrs)
      assert %{"id" => ^id} = json_response(update_conn, 200)["data"]

      conn = get(conn, Routes.api_frobot_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brain_code" => "some updated brain_code",
               "class" => "some updated class",
               "name" => "some updated name",
               "xp" => 43
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "god"
    test "renders errors when data is invalid", %{conn: conn, frobot: frobot} do
      conn = put(conn, Routes.api_frobot_path(conn, :update, frobot), frobot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete frobot" do
    setup [:login, :create_frobot]

    @tag login_as: "god"
    test "deletes chosen frobot", %{conn: conn, frobot: frobot} do
      delete_conn = delete(conn, Routes.api_frobot_path(conn, :delete, frobot))
      assert response(delete_conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_frobot_path(conn, :show, frobot))
      end
    end
  end

  defp create_frobot(%{conn: conn}) do
    frobot = frobot_fixture(conn.assigns.current_user)
    %{conn: conn, frobot: frobot}
  end

  defp login(%{conn: conn, login_as: username}) do
    user = user_fixture(username: username)
    conn = assign(conn, :current_user, user)
    %{conn: conn, user: user}
  end
end
