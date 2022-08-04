defmodule FrobotsWeb.Api.LeaderboardController do
  use FrobotsWeb, :controller
  alias Frobots.Events

  action_fallback FrobotsWeb.FallbackController

  @dummy_response [
    %{"attempts" => 213, "points" => 0, "username" => "god"},
    %{"attempts" => 7, "points" => 0, "username" => "bob"},
    %{"attempts" => 5, "points" => 0, "username" => "jerry"}
  ]

  def index(conn, _params) do
    # populate agent
    check_all = fn res ->
      Enum.all?(res, &(:ok == &1))
    end

    case check_all.(Events.prep_leaderboard_entries()) do
      true ->
        entries = Events.send_leaderboard_entries()
        conn |> put_status(200) |> json(entries)

      false ->
        entries = Events.send_leaderboard_entries()
        conn |> put_status(200) |> json(entries)
    end
  end
end
