defmodule FrobotsWeb.FrobotEquipmentBayLive do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "lists all equipements of frobot", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.garage_frobotslist(conn, :index))

      assert html =~
               "<div id=\"frobot-equipment-bay\" phx-hook=\"FrobotEquipmentBayHook\" phx-update=\"ignore\"></div>"
    end
  end
end
