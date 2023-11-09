defmodule FrobotsWeb.TournamentListLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Api, Accounts, Events}

  # Try live render from parent to not have new analytics data....
  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    tournaments = extract_tournamentdetails(Api.list_paginated_tournaments().entries)
    s3_base_url = Api.get_s3_base_url()
    arenas = Api.list_arena()

    {:ok,
     socket
     |> assign(:tournaments, tournaments)
     |> assign(:s3_base_url, s3_base_url)
     |> assign(:arenas, arenas)
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )
     |> assign(:current_user, current_user)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("react.fetch_tournaments_list", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_tournaments_list", %{
       "tournaments" => socket.assigns.tournaments,
       "s3_base_url" => socket.assigns.s3_base_url,
       "arenas" => socket.assigns.arenas,
       "isAdmin" => socket.assigns.current_user.admin
     })}
  end

  def extract_tournamentdetails(tournaments) do
    Enum.map(
      tournaments,
      fn %{
           id: id,
           arena_id: arena_id,
           arena_fees_percent: arena_fees_percent,
           description: description,
           name: name,
           starts_at: starts_at,
           status: status
         } ->
        %{
          id: id,
          arena_id: arena_id,
          arena_fees_percent: arena_fees_percent,
          description: description,
          name: name,
          starts_at: starts_at,
          status: status
        }
      end
    )
  end
end
