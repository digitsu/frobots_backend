defmodule FrobotsWeb.ArenaLobbyLive do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "Arena Lobby Ui render", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.arena_lobby(conn, :index))

      assert html =~
               "<div id=\"arena-lobby\" phx-hook=\"ArenaLobbyHook\" phx-update=\"ignore\"></div>"
    end
  end
end
