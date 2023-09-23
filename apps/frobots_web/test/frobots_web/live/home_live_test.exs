defmodule FrobotsWeb.HomeLiveTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "users can create todos", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.home_index_path(conn, :index))

      assert html =~
               "<div id=\"dashboard-content\" phx-hook=\"DashboardContentHook\" phx-update=\"ignore\"></div>"
    end
  end

  describe "Test Ghost Blog Basic" do
    setup [:create_user, :register_and_log_in_user]

    test "Try to get the ghost blog in test, should return nothing", %{conn: _conn} do
      assert FrobotsWeb.Utils.get_blog_posts() == []
    end
  end
end
