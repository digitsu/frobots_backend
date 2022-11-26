defmodule FrobotsWeb.HomeLiveTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  use ExUnit.Case, async: true
  # use Wallaby.Feature

  # import Wallaby.Query, only: [css: 2, text_field: 1, button: 1]

  describe "Index" do
    test "users can create todos", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.home_index_path(conn, :index))
      assert html =~ "User lands here after logging in."
    end
  end
end
