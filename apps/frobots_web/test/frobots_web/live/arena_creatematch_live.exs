defmodule FrobotsWeb.ArenaCreateMatchLive do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "Arena Create match ui render", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.arena(conn, :index))

      assert html =~
               "<div id='arena-create-match' phx-hook='ArenaCreateMatch' phx-update='ignore'></div>"
    end
  end
end
