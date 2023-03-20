defmodule FrobotsWeb.Api.MatchController do
  use FrobotsWeb, :controller

  action_fallback FrobotsWeb.FallbackController

  def index(conn, params) do
    # {
    #   "matchId:"match-id",
    #   "status":"SCHEDULED",
    #   "title":"My Match",
    #   "description":"Sample description",
    #   "matchTime":"2023-03-28T00:00:00",
    #   "timer":"01:00:00",  //"00:00:00" fight until death last man standing wins
    #   "arena":"arena-id",
    #   "minPlayerFrobot":1,
    #   "maxPlayerFrobot":2,
    #   "slots":[
    #     {
    #       "frobotId":"frobot-a",
    #       "slotType":"HOST"
    #     },
    #     {
    #       "frobotId":"rabbit"
    #       "slotType":"PROTOBOT"
    #     },
    #        {
    #       "frobotId":null
    #       "slotType":"CLOSED"
    #     }
    #   ]
    # }
    ## Create Match usinhg Match API
    ## Create a Scheduled Tournament in Nakama
    response = params |> Map.put("matchId", 1) |> Map.put("status", "SCHEDULED")
    conn |> put_status(200) |> json(response)
  end
end
