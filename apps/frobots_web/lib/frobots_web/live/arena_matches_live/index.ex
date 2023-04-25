defmodule FrobotsWeb.ArenaMatchesLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias FrobotsWeb.Router.Helpers, as: Routes
  alias Frobots.Api
  alias Frobots.Events
  alias Frobots.Accounts

  # Try live render from parent to not have new analytics data....
  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    ## running, done, pending
    match_status = params["match_status"]
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    matches = Api.list_matches_by_status_for_user(match_status, current_user.id)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:joined_matches, matches["joined"])
     |> assign(:host_matches, matches["host"])
     |> assign(:match_status, match_status)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end
end
