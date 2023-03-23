defmodule FrobotsWeb.ArenaMatchesLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias FrobotsWeb.Router.Helpers, as: Routes
  alias Frobots.Events
  alias Frobots.Accounts

  # Try live render from parent to not have new analytics data....
  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    ## running, done, pending
    match_status = params["match_status"]
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    %{
      entries: matches,
      page_number: page,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches([status: match_status], [], [:user], desc: :inserted_at)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:matches, matches)
     |> assign(:match_status, match_status)
     |> assign(:page, page)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)
     |> assign(:live_matches, Events.count_matches_by_status(:running))
     |> assign(:completed_matches, Events.count_matches_by_status(:done))
     |> assign(:upcoming_matches, Events.count_matches_by_status(:pending))}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(%{"page" => page} = params, _, socket) do
    match_status = params["match_status"]

    %{
      entries: matches,
      page_number: page,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } =
      Events.list_paginated_matches([status: match_status], [page: page], [:user],
        desc: :inserted_at
      )

    {:noreply,
     socket
     |> assign(:matches, matches)
     |> assign(:page, page)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
