defmodule FrobotsWeb.ArenaLive.Index do
  use FrobotsWeb, :live_view

  @impl Phoenix.LiveView
  alias Frobots.Events

  @spec mount(any, nil | maybe_improper_list | map, map) :: {:ok, map}
  def mount(params, session, socket) do
    # current_user = Accounts.get_user_by_session_token(session["user_token"])
    IO.inspect(params, label: "Params")
    IO.inspect(session, label: "Session")
    IO.inspect(socket, label: "socket")
    if connected?(socket), do: Events.subscribe()

    %{
      entries: matches,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches()

    {:ok,
     socket
     # |> assign(:current_user, current_user)
     |> assign(:matches, matches)
     |> assign(:page_number, page_number)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)}
  end

  @impl Phoenix.LiveView
  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply,
     live_redirect(socket,
       to: Routes.arena_index_path(socket, FrobotsWeb.ArenaLive.Index, page: page)
     )}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(%{"page" => page_number}, _, socket) do
    %{
      entries: matches,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches([page: page_number], [:user], desc: :inserted_at)

    {:noreply,
     socket
     |> assign(:matches, matches)
     |> assign(:page_number, page_number)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({Events, [:match, :created], match}, socket) do
    IO.inspect(self(), label: "Self PID")
    IO.inspect(match, label: "Match Cerated received")
    {:noreply, socket}
  end
end
