defmodule FrobotsWeb.Api.LeaderboardControllerTest do
  use FrobotsWeb.ConnCase, async: true

  # todo -- add a test to test the shape of the data
  # [
  #   %{"attempts" => 213, "points" => 0, "username" => "god"},
  #   %{"attempts" => 7, "points" => 0, "username" => "god"},
  #   %{"attempts" => 5, "points" => 0, "username" => "jerry"}
  # ]
  describe "test leaderboard api" do
    test "GET /api/v1/leaderboard", %{conn: conn} do
      conn = get(conn, Routes.api_leaderboard_path(conn, :index))
      assert json_response(conn, 200)
    end
  end
end
