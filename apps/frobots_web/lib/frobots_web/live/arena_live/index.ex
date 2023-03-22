defmodule FrobotsWeb.ArenaLive.Index do
  use FrobotsWeb, :live_view

  @impl Phoenix.LiveView

  alias FrobotsWeb.Router.Helpers, as: Routes
  alias Frobots.Events
  alias Frobots.Accounts

  @spec mount(any, nil | maybe_improper_list | map, map) :: {:ok, map}
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    %{
      entries: matches,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches([], [:user], desc: :inserted_at)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:matches, matches)
     |> assign(:page_number, page_number)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)
     |> assign(:live_matches, Events.count_matches_by_status(:running))
     |> assign(:completed_matches, Events.count_matches_by_status(:done))
     |> assign(:upcoming_matches, Events.count_matches_by_status(:pending))}
  end

  @impl Phoenix.LiveView
  def handle_event("navigate", %{"page" => page}, socket) do
    {:noreply,
     live_redirect(socket,
       to: Routes.arena_index_path(socket, FrobotsWeb.ArenaLive.Index, page: page)
     )}
  end

  def handle_event("create", %{"match" => _match_details}, socket) do
    params = %{
      "user_id" => socket.assign.current_user.id,
      "title" => "My Match",
      "description" => "Match description",
      "match_time" => DateTime.utc_now() |> DateTime.to_string(),
      # 1 hour
      "timer" => 3600,
      "arena_id" => 1,
      "min_player_frobot" => 1,
      "max_player_frobot" => 3,
      "slots" => [
        %{
          "frobot_id" => 1,
          "status" => "ready",
          "slot_type" => "host"
        },
        %{
          "frobot_id" => 2,
          "status" => "ready",
          "slot_type" => "protobot"
        },
        %{
          "frobot_id" => nil,
          "status" => "closed",
          "slot_type" => "closed"
        }
      ],
      "match_template" => %{
        "entry_fee" => 100,
        "commission_rate" => 10,
        "match_type" => "team",
        "payout_map" => [100],
        "max_frobots" => 3,
        "min_frobots" => 1
      }
    }

    Events.create_match(params)
    {:noreply, socket}
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
    matches = socket.assign.matches
    page_size = socket.assign.page_size

    updated_matches =
      if length(matches) < page_size do
        [match | matches]
      else
        [match | List.delete_at(matches, length(matches) - 1)]
      end

    {:noreply, socket |> assign(:matches, updated_matches)}
  end

  def handle_info({Events, [:match, :updated], match}, socket) do
    matches = socket.assign.matches

    updated_matches =
      Enum.map(matches, fn old_match ->
        if old_match.id == match.id, do: match, else: old_match
      end)

    {:noreply, socket |> assign(:matches, updated_matches)}
  end
end
