defmodule FrobotsWeb.GarageFrobotsDetailsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Assets, Api, Events}

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    s3_base_url = Api.get_s3_base_url()

    # get frobot id or name from the url param
    frobot_id_or_name =
      if params["id"] && params["id"] !== "" do
        String.to_integer(params["id"])
      else
        params["name"]
      end

    # if frobot_id_or_name not exist, redirect user to garage
    if frobot_id_or_name !== nil and frobot_id_or_name !== "" do
      case Api.get_frobot_details(frobot_id_or_name) do
        {:ok, frobot_details} ->
          %{
            entries: battles,
            page_number: page,
            page_size: page_size,
            total_entries: total_entries
          } =
            Api.list_paginated_frobot_battlelog([frobot_id: frobot_details["frobot_id"]],
              page: 1,
              page_size: 5
            )

          {:ok,
           socket
           |> assign(:user, current_user)
           |> assign(
             :current_user_ranking_details,
             Events.get_current_user_ranking_details(current_user)
           )
           |> assign(:frobot, frobot_details)
           |> assign(:user_frobots, Assets.list_user_frobots(current_user))
           |> assign(:battles, battles)
           |> assign(:page, page)
           |> assign(:page_size, page_size)
           |> assign(:total_entries, total_entries)
           |> assign(:s3_base_url, s3_base_url)}

        {:error, message} ->
          {:ok,
           socket
           |> put_flash(:error, message)
           |> push_redirect(to: "/garage")}
      end
    else
      {:ok,
       socket
       |> put_flash(:error, "Frobot id / name not specified in the url")
       |> push_redirect(to: "/garage")}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("react.fetch_frobot_details", _params, socket) do
    frobot = socket.assigns.frobot
    current_user = socket.assigns.user
    user_frobots = extract_frobots(socket.assigns.user_frobots)

    currentUser = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_frobot_details", %{
       "frobotDetails" => frobot,
       "currentUser" => currentUser,
       "userFrobots" => user_frobots,
       "battles" => socket.assigns.battles,
       "total_entries" => socket.assigns.total_entries,
       "page" => socket.assigns.page,
       "page_size" => socket.assigns.page_size,
       "s3_base_url" => socket.assigns.s3_base_url
     })}
  end

  def handle_event("react.filter_frobot_battle_logs", params, socket) do
    filter_params = Keyword.new()

    filter_params =
      if params["frobot_id"],
        do: Keyword.put(filter_params, :frobot_id, params["frobot_id"]),
        else: filter_params

    filter_params =
      if params["match_status"],
        do: Keyword.put(filter_params, :match_status, params["match_status"]),
        else: filter_params

    page_config = Keyword.new()

    page_config =
      if params["page"],
        do: Keyword.put(page_config, :page, params["page"]),
        else: Keyword.put(page_config, :page, 1)

    page_config =
      if params["page_size"],
        do: Keyword.put(page_config, :page_size, params["page_size"]),
        else: Keyword.put(page_config, :page_size, 5)

    %{
      entries: battles,
      page_number: page,
      page_size: page_size,
      total_entries: total_entries
    } = Api.list_paginated_frobot_battlelog(filter_params, page_config)

    frobot = socket.assigns.frobot
    current_user = socket.assigns.user
    user_frobots = extract_frobots(socket.assigns.user_frobots)

    currentUser = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_frobot_details", %{
       "frobotDetails" => frobot,
       "currentUser" => currentUser,
       "userFrobots" => user_frobots,
       "battles" => battles,
       "total_entries" => total_entries,
       "page" => page,
       "page_size" => page_size,
       "match_status" => params["match_status"],
       "s3_base_url" => socket.assigns.s3_base_url
     })}
  end

  def extract_frobots(frobots) do
    Enum.map(
      frobots,
      fn %{
           id: id,
           name: name,
           brain_code: brain_code,
           class: class,
           xp: xp,
           blockly_code: blockly_code,
           avatar: avatar,
           bio: bio,
           pixellated_img: pixellated_img,
           user_id: user_id,
           inserted_at: inserted_at,
           updated_at: updated_at
         } ->
        %{
          id: id,
          name: name,
          brain_code: brain_code,
          class: class,
          xp: xp,
          blockly_code: blockly_code,
          avatar: avatar,
          bio: bio,
          pixellated_img: pixellated_img,
          user_id: user_id,
          inserted_at: inserted_at,
          updated_at: updated_at
        }
      end
    )
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
