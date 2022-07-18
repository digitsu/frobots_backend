defmodule FrobotsWeb.Api.LeaderboardController do
  use FrobotsWeb, :controller
  alias Frobots.Events

  action_fallback FrobotsWeb.FallbackController

  def index(conn, _params) do
    # populate agent
    Events.prep_leaderboard_entries()
    # read processed data from agent
    entries = Events.send_leaderboard_entries()

    conn
    |> put_status(200)
    |> json(entries)
  end
end
