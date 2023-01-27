defmodule FrobotsWeb.Api.TokenControllerTest do
  use FrobotsWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Ensure nothing works if not logged in" do
    test "requires user login on all actions", %{conn: conn} do
      conn = get(conn, Routes.api_token_path(conn, :gen_token))
      assert json_response(conn, 401)
      assert conn.halted
    end
  end

  describe "generate a token" do
    setup [:basic_auth_login]

    @tag login_as: "admin@mail.com"
    test "admin api login", %{conn: conn} do
      conn = get(conn, Routes.api_token_path(conn, :gen_token))
      assert %{"token" => _} = json_response(conn, 200)["data"]
    end

    @tag login_as: "somedude@mail.com"
    test "non-admin login also should work", %{conn: conn} do
      conn = get(conn, Routes.api_token_path(conn, :gen_token))
      assert %{"token" => _} = json_response(conn, 200)["data"]
    end
  end
end
