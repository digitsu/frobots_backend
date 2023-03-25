defmodule FrobotsWeb.ArenaLive.Index do
  use FrobotsWeb, :live_view

  alias FrobotsWeb.Router.Helpers, as: Routes
  alias Frobots.Events
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    page_config = Keyword.new()

    page_config =
      if params["page"],
        do: Keyword.put(page_config, :page, params["page"]),
        else: page_config

    page_config =
      if params["page_size"],
        do: Keyword.put(page_config, :page_size, params["page_size"]),
        else: page_config

    if connected?(socket), do: Events.subscribe()

    %{
      entries: matches,
      page_number: page,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches([], page_config, [:user], desc: :inserted_at)

    %{entries: upcoming_matches} =
      Events.list_paginated_matches([match_status: :pending], page_config, [:user],
        desc: :inserted_at
      )

    %{entries: completed_matches} =
      Events.list_paginated_matches([match_status: :done], page_config, [:user],
        desc: :inserted_at
      )

    %{entries: live_matches} =
      Events.list_paginated_matches([match_status: :running], page_config, [:user],
        desc: :inserted_at
      )

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:match_status, params["match_status"])
     |> assign(:matches, matches)
     |> assign(:upcoming_matches_list, upcoming_matches)
     |> assign(:completed_matches_list, completed_matches)
     |> assign(:live_matches_list, live_matches)
     |> assign(:page, page)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)
     |> assign(:live_matches_count, Events.count_matches_by_status(:running))
     |> assign(:completed_matches_count, Events.count_matches_by_status(:done))
     |> assign(:upcoming_matches_count, Events.count_matches_by_status(:pending))}
  end

  # %{
  #   "title" => "My Match",
  #   "description" => "Match description",
  #   "match_time" => DateTime.utc_now() |> DateTime.to_string(),
  #   # 1 hour
  #   "timer" => 3600,
  #   "arena_id" => 1,
  #   "min_player_frobot" => 1,
  #   "max_player_frobot" => 3,
  #   "slots" => [
  #     %{
  #       "frobot_id" => 1,
  #       "status" => "ready",
  #       "slot_type" => "host"
  #     },
  #     %{
  #       "frobot_id" => 2,
  #       "status" => "ready",
  #       "slot_type" => "protobot"
  #     },
  #     %{
  #       "status" => "closed",
  #       "slot_type" => "closed"
  #     }
  #   ]
  # }
  @impl Phoenix.LiveView
  def handle_event("create", %{"match" => match_details}, socket) do
    match_details =
      match_details
      |> Map.put_new("user_id", socket.assigns.current_user.id)

    case Frobots.Api.create_match(match_details) do
      {:ok, match} ->
        {:noreply,
         push_redirect(socket, to: Routes.arena_lobby_index_path(socket, :index, match.id))}

      {:error, changeset} ->
        {:noreply, assign(socket, match_changeset: changeset)}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(%{"page" => _page} = params, _, socket) do
    filter_params = Keyword.new()

    filter_params =
      if params["match_status"],
        do: Keyword.put(filter_params, :match_status, params["match_status"]),
        else: filter_params

    filter_params =
      if params["search_pattern"],
        do: Keyword.put(filter_params, :search_pattern, params["search_pattern"]),
        else: filter_params

    page_config = Keyword.new()

    page_config =
      if params["page"],
        do: Keyword.put(page_config, :page, params["page"]),
        else: page_config

    page_config =
      if params["page_size"],
        do: Keyword.put(page_config, :page_size, params["page_size"]),
        else: page_config

    %{
      entries: matches,
      page_number: page,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    } = Events.list_paginated_matches(filter_params, page_config, [:user], desc: :inserted_at)

    socket =
      case params["match_status"] do
        "done" -> socket |> assign(:completed_matches_list, matches)
        "running" -> socket |> assign(:live_matches_list, matches)
        "pending" -> socket |> assign(:upcoming_matches_list, matches)
        _ -> socket |> assign(:matches, matches)
      end

    {:noreply,
     socket
     |> assign(:match_status, params["match_status"])
     |> assign(:page, page)
     |> assign(:page_size, page_size)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({Events, [:match, :created], match}, socket) do
    page_size = socket.assigns.page_size

    socket =
      if is_nil(socket.assigns.match_status) do
        matches = socket.assigns.matches

        updated_matches =
          if length(matches) < page_size do
            [match | matches]
          else
            [match | List.delete_at(matches, length(matches) - 1)]
          end

        socket |> assign(:matches, updated_matches)
      else
        socket
      end

    socket =
      if socket.assigns.match_status == "pending" do
        matches = socket.assigns.upcoming_matches

        updated_matches =
          if length(matches) < page_size do
            [match | matches]
          else
            [match | List.delete_at(matches, length(matches) - 1)]
          end

        socket |> assign(:upcoming_matches, updated_matches)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_info({Events, [:match, :updated], match}, socket) do
    socket =
      if is_nil(socket.assigns.match_status) do
        matches = socket.assigns.matches

        updated_matches =
          Enum.map(matches, fn old_match ->
            if old_match.id == match.id, do: match, else: old_match
          end)

        socket |> assign(:matches, updated_matches)
      else
        socket
      end

    socket =
      if socket.assigns.match_status == "pending" do
        matches = socket.assigns.upcoming_matches

        updated_matches =
          Enum.map(matches, fn old_match ->
            if old_match.id == match.id, do: match, else: old_match
          end)

        socket |> assign(:upcoming_matches, updated_matches)
      else
        socket
      end

    socket =
      if socket.assigns.match_status == "done" do
        matches = socket.assigns.completed_matches

        updated_matches =
          Enum.map(matches, fn old_match ->
            if old_match.id == match.id, do: match, else: old_match
          end)

        socket |> assign(:completed_matches, updated_matches)
      else
        socket
      end

    socket =
      if socket.assigns.match_status == "live" do
        matches = socket.assigns.live_matches

        updated_matches =
          Enum.map(matches, fn old_match ->
            if old_match.id == match.id, do: match, else: old_match
          end)

        socket |> assign(:live_matches, updated_matches)
      else
        socket
      end

    {:noreply, socket}
  end
end
