defmodule FrobotsWeb.FrobotViewTest do
  use FrobotsWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    frobots = [
      %Frobots.Assets.Frobot{id: "1", name: "backbreaker"},
      %Frobots.Assets.Frobot{id: "2", name: "nutcracker"}
    ]

    content =
      render_to_string(
        FrobotsWeb.FrobotView,
        "index.html",
        conn: conn,
        frobots: frobots
      )

    assert String.contains?(content, "Listing Frobots")

    for frobot <- frobots do
      assert String.contains?(content, frobot.name)
    end
  end

  test "renders new.html", %{conn: conn} do
    _owner = %Frobots.Accounts.User{}
    changeset = Frobots.Assets.change_frobot(%Frobots.Assets.Frobot{})

    content =
      render_to_string(FrobotsWeb.FrobotView, "new.html",
        conn: conn,
        changeset: changeset
      )

    assert String.contains?(content, "New Frobot")
  end
end
