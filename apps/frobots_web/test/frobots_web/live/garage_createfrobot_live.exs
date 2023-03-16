defmodule FrobotsWeb.GarageFrobotCreateLive do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias FrobotsWeb.ConnCase

  describe "Index" do
    setup [:create_user, :register_and_log_in_user]

    test "Create frobot stepper form", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.garage_createfrobot(conn, :index))

      assert html =~
               "<div id=\"create-frobot\" phx-hook=\"FrobotCreateHook\" phx-update=\"ignore\"></div>"
    end
  end
end
