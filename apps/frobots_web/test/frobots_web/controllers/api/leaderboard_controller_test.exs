defmodule FrobotsWeb.Api.LeaderboardControllerTest do
  use FrobotsWeb.ConnCase, async: true

  describe "test leaderboard api" do
    test "GET /api/v1/leaderboard", %{conn: conn} do
      conn = get(conn, Routes.api_leaderboard_path(conn, :index))
      assert json_response(conn, 200)
    end
  end

end
