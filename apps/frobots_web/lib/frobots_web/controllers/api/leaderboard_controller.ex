defmodule FrobotsWeb.Api.LeaderboardController do
  use FrobotsWeb, :controller
  alias Frobots.Leaderboard

  action_fallback FrobotsWeb.FallbackController

  # @dummy_response [
  #   %{"attempts" => 213, "points" => 0, "username" => "god"},
  #   %{"attempts" => 7, "points" => 0, "username" => "bob"},
  #   %{"attempts" => 5, "points" => 0, "username" => "jerry"}
  # ]

  def index(conn, _params) do
    entries = Leaderboard.get_frobot_leaderboard()
    conn |> put_status(200) |> json(entries)
  end
end
