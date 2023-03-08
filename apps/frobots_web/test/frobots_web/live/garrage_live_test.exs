defmodule FrobotsWeb.HomeLiveTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "users can create todos", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.home_index_path(conn, :index))

      assert html =~
               "<div id=\"frobots-list\" phx-hook=\"FrobotsListHook\" phx-update=\"ignore\"></div>"
    end
  end
end
