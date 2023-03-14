defmodule FrobotsWeb.ArenaLiveMatchesLive do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "Arena past matches home ui render", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.arena(conn, :index))

      assert html =~
               "<div id='arena-past-matches' phx-hook='ArenaPastMatchesContentHook' phx-update='ignore'></div>"
    end
  end
end
