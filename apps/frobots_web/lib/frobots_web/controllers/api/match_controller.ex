defmodule FrobotsWeb.Api.LeaderboardController do
  use FrobotsWeb, :controller

  action_fallback FrobotsWeb.FallbackController

  def index(conn, params) do
    response = params |> Map.put("matchId", 1) |> Map.put("status", "SCHEDULED")
    conn |> put_status(200) |> json(response)
  end
end
