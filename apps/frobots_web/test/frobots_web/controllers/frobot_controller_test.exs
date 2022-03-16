defmodule FrobotsWeb.FrobotControllerTest do
  use FrobotsWeb.ConnCase

  import Frobots.AssetsFixtures

  @create_attrs %{brain_code: "some brain_code", class: "some class", name: "some name", xp: 42}
  @update_attrs %{
    brain_code: "some updated brain_code",
    class: "some updated class",
    name: "some updated name",
    xp: 43
  }
  @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}

  describe "index" do
    test "lists all frobots", %{conn: conn} do
      conn = get(conn, Routes.frobot_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Frobots"
    end
  end

  describe "new frobot" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.frobot_path(conn, :new))
      assert html_response(conn, 200) =~ "New Frobot"
    end
  end

  describe "create frobot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.frobot_path(conn, :create), frobot: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.frobot_path(conn, :show, id)

      conn = get(conn, Routes.frobot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Frobot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.frobot_path(conn, :create), frobot: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Frobot"
    end
  end

  describe "edit frobot" do
    setup [:create_frobot]

    test "renders form for editing chosen frobot", %{conn: conn, frobot: frobot} do
      conn = get(conn, Routes.frobot_path(conn, :edit, frobot))
      assert html_response(conn, 200) =~ "Edit Frobot"
    end
  end

  describe "update frobot" do
    setup [:create_frobot]

    test "redirects when data is valid", %{conn: conn, frobot: frobot} do
      conn = put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @update_attrs)
      assert redirected_to(conn) == Routes.frobot_path(conn, :show, frobot)

      conn = get(conn, Routes.frobot_path(conn, :show, frobot))
      assert html_response(conn, 200) =~ "some updated brain_code"
    end

    test "renders errors when data is invalid", %{conn: conn, frobot: frobot} do
      conn = put(conn, Routes.frobot_path(conn, :update, frobot), frobot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Frobot"
    end
  end

  describe "delete frobot" do
    setup [:create_frobot]

    test "deletes chosen frobot", %{conn: conn, frobot: frobot} do
      conn = delete(conn, Routes.frobot_path(conn, :delete, frobot))
      assert redirected_to(conn) == Routes.frobot_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.frobot_path(conn, :show, frobot))
      end
    end
  end

  defp create_frobot(_) do
    frobot = frobot_fixture()
    %{frobot: frobot}
  end
end
