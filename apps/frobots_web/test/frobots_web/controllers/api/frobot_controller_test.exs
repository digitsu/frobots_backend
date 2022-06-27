defmodule FrobotsWeb.Api.FrobotControllerTest do
  use FrobotsWeb.ConnCase, async: true

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
    setup [:api_login]
    @tag login_as: "admin"
    test "lists all frobots", %{conn: conn} do
      conn = get(conn, Routes.api_frobot_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create frobot" do
    setup [:api_login]

    @tag login_as: "admin"
    test "renders frobot when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_frobot_path(conn, :create), frobot: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_frobot_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brain_code" => "some brain_code",
               "class" => "some class",
               "name" => "some name",
               "xp" => 42
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "admin"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_frobot_path(conn, :create), frobot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update frobot" do
    setup [:api_login, :create_frobot]

    @tag login_as: "admin"
    test "renders frobot when data is valid", %{conn: conn, frobot: %Frobot{id: id} = frobot} do
      conn = put(conn, Routes.api_frobot_path(conn, :update, frobot), frobot: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_frobot_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "brain_code" => "some updated brain_code",
               "class" => "some updated class",
               "name" => "some updated name",
               "xp" => 43
             } = json_response(conn, 200)["data"]
    end

    @tag login_as: "admin"
    test "renders errors when data is invalid", %{conn: conn, frobot: frobot} do
      conn = put(conn, Routes.api_frobot_path(conn, :update, frobot), frobot: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete frobot" do
    setup [:api_login, :create_frobot]

    @tag login_as: "admin"
    test "deletes chosen frobot", %{conn: conn, frobot: frobot} do
      conn = delete(conn, Routes.api_frobot_path(conn, :delete, frobot))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_frobot_path(conn, :show, frobot))
      end
    end
  end


end
