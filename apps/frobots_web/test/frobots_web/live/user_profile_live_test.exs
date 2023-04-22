defmodule FrobotsWeb.UserProfileLiveTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "Display user profile details", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.user_profile_index_path(conn, :index))

      assert html =~
               "<div id=\"user-profile\" phx-hook=\"UserProfileHook\" phx-update=\"ignore\"></div>"
    end
  end
end
