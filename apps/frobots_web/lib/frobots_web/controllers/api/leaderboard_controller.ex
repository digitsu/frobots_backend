defmodule FrobotsWeb.Api.LeaderboardController do
  use FrobotsWeb, :controller
  alias Frobots.Events

  action_fallback FrobotsWeb.FallbackController

  def index(conn, _params) do
    # populate agent
    check_all = fn res ->
      Enum.all?(res, & (:ok == &1))
    end
    case check_all.(Events.prep_leaderboard_entries()) do
      true -> entries = Events.send_leaderboard_entries()
        conn |> put_status(200) |> json(entries)
      false ->
        conn |> put_status(500) |> halt()
    end
  end
end
