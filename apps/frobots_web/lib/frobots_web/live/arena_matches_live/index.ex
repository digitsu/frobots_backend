defmodule FrobotsWeb.ArenaMatchesLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.Api
  alias Frobots.Events
  alias Frobots.Accounts

  # Try live render from parent to not have new analytics data....
  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    ## running, done, pending
    match_status = params["match_status"]
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    matches = Api.list_matches_by_status_for_user(match_status, current_user.id)

    display_status_name =
      if match_status === "pending" do
        "Upcoming"
      else
        if match_status === "running" do
          "Live"
        else
          "Completed"
        end
      end

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:joined_matches, Map.get(matches, "joined", []))
     |> assign(:host_matches, Map.get(matches, "host", []))
     |> assign(:watch_matches, Map.get(matches, "watch", []))
     |> assign(:arenas, Api.list_arena())
     |> assign(:match_status, match_status)
     |> assign(:display_status_name, display_status_name)
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )
     |> assign(:s3_base_url, Api.get_s3_base_url())}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("react.fetch_arena_matches", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_arena_matches", %{
       "arenas" => socket.assigns.arenas,
       "match_status" => socket.assigns.match_status,
       "joined_matches" => socket.assigns.joined_matches,
       "host_matches" => socket.assigns.host_matches,
       "watch_matches" => socket.assigns.watch_matches,
       "s3_base_url" => socket.assigns.s3_base_url
     })}
  end
end
