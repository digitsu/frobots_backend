defmodule FrobotsWeb.ArenaLobbyLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Api, Events, Assets, Accounts}
  alias PhoenixClient.{Socket, Channel}

  @impl Phoenix.LiveView
  def mount(
        %{"match_id" => match_id} = _params,
        %{"user_id" => id, "user_token" => user_token},
        socket
      ) do
    match = Api.get_match_details_by_id(match_id)
    s3_base_url = Api.get_s3_base_url()
    current_user = Accounts.get_user_by_session_token(user_token)

    if is_nil(match) do
      {:noreply, put_flash(socket, :error, "invalid match id")}
    else
      if connected?(socket), do: Events.subscribe()

      time_left =
        if match.status == :pending or match.status == :running do
          Process.send_after(self(), :time_left, 1_000)
          DateTime.diff(match.match_time, DateTime.utc_now())
        else
          nil
        end

      {:ok,
       socket
       |> assign(:match, match)
       |> assign(:time_left, time_left)
       |> assign(:user_id, id)
       |> assign(:s3_base_url, s3_base_url)
       |> assign(
         :current_user_ranking_details,
         Events.get_current_user_ranking_details(current_user)
       )}
    end
  end

  @impl Phoenix.LiveView
  def handle_event(event, %{"slot_id" => slot_id} = params, socket)
      when event in ["joining", "ready", "closed", "open"] do
    match = socket.assigns.match
    current_user_id = socket.assigns.user_id

    slot_type = params["slot_type"] |> to_atom()
    frobot_id = params["frobot_id"]

    attrs =
      case event do
        "joining" ->
          %{status: "joining", slot_type: slot_type}

        "ready" ->
          %{status: "ready", slot_type: slot_type, frobot_id: frobot_id}

        "closed" ->
          %{status: "closed", slot_type: nil}

        "open" ->
          %{status: "open", slot_type: nil}
      end

    case Api.update_slot(match, current_user_id, slot_id, attrs) do
      {:ok, updated_slot} ->
        updated_slots =
          Enum.reduce(match.slots |> Enum.reverse(), [], fn slot, acc ->
            if slot.id == updated_slot.id do
              [Map.put(slot, :status, updated_slot.status) | acc]
            else
              [slot | acc]
            end
          end)
          |> Enum.sort_by(& &1.id)

        updated_match = Map.put(match, :slots, updated_slots)
        {:noreply, socket |> assign(:match, updated_match)}

      {:error, :slot_not_found} ->
        {:noreply, put_flash(socket, :error, "invalid slot id")}

      {:error, changeset} ->
        {:noreply, assign(socket, match_changeset: changeset)}
    end
  end

  def handle_event("start_match", _params, socket) do
    match_id = socket.assigns.match_id
    socket_opts = Application.get_env(:phoenix_client, :socket)
    {:ok, phoenix_socket} = Socket.start_link(socket_opts)
    wait_for_socket(phoenix_socket)

    {:ok, _response, match_channel} =
      Channel.join(phoenix_socket, "match:" <> Integer.to_string(match_id))

    wait_for_socket(phoenix_socket)

    case Channel.push(match_channel, "start_match", %{"id" => match_id}) do
      {:ok, _frobots_map} ->
        ## Redirect to a page where they are listing to the channel for events
        {:noreply, socket |> assign(:match_channel, match_channel)}

      {:error, error} ->
        {:noreply, socket |> assign(:match_channel, match_channel) |> put_flash(:error, error)}
    end
  end

  def handle_event("react.fetch_lobby_details", %{}, socket) do
    %{match: match, user_id: user_id, s3_base_url: s3_base_url} = socket.assigns
    templateFrobots = extract_frobot_details(Assets.list_template_frobots())

    userFrobots =
      extract_frobot_details(Assets.get_available_user_frobots(socket.assigns.user_id))

    {:noreply,
     push_event(socket, "react.return_lobby_details", %{
       "match" => %{
         "id" => match.id,
         "slots" => extract_slot_details(match.slots),
         "description" => match.description,
         "title" => match.title,
         "timer" => match.timer,
         "max_player_frobot" => match.max_player_frobot,
         "min_player_frobot" => match.min_player_frobot,
         "match_time" => match.match_time
       },
       "user_id" => match.user_id,
       "current_user_id" => user_id,
       "templates" => templateFrobots,
       "frobots" => userFrobots,
       "s3_base_url" => s3_base_url
     })}
  end

  def handle_event("match_results", %{}, socket) do
    match_id = socket.assigns.match.id

    {:noreply,
     push_event(socket, "react.return_match_results", %{
       "match_results" => Events.get_match_details(match_id)
     })}
  end

  defp wait_for_socket(socket) do
    unless Socket.connected?(socket) do
      wait_for_socket(socket)
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({Events, [:slot, :updated], updated_slot}, socket) do
    match = socket.assigns.match

    updated_slots =
      Enum.reduce(match.slots |> Enum.reverse(), [], fn slot, acc ->
        if slot.id == updated_slot.id do
          [Map.put(slot, :status, updated_slot.status) | acc]
        else
          [slot | acc]
        end
      end)
      |> Enum.sort_by(& &1.id)

    updated_match = Map.put(match, :slots, updated_slots)
    {:noreply, socket |> assign(:match, updated_match)}
  end

  def handle_info(:time_left, socket) do
    match = socket.assigns.match
    time_left = DateTime.diff(match.match_time, DateTime.utc_now())
    Process.send_after(self(), :time_left, 1_000)
    {:noreply, socket |> assign(:time_left, time_left)}
  end

  defp to_atom(value) when is_binary(value), do: String.to_atom(value)
  defp to_atom(value), do: value

  defp extract_frobot_details(frobots) do
    Enum.map(frobots, fn %{
                           id: id,
                           name: name,
                           xp: xp,
                           class: class,
                           brain_code: brain_code,
                           blockly_code: blockly_code,
                           bio: bio,
                           avatar: avatar
                         } ->
      %{
        id: id,
        name: name,
        xp: xp,
        class: class,
        brain_code: brain_code,
        blockly_code: blockly_code,
        bio: bio,
        avatar: avatar
      }
    end)
  end

  defp extract_slot_details(slots) do
    Enum.map(slots, fn %{
                         frobot: frobot,
                         frobot_id: frobot_id,
                         id: id,
                         match_id: match_id,
                         slot_type: slot_type,
                         status: status
                       } ->
      user_id =
        if frobot do
          Map.get(frobot, :user_id, nil)
        else
          nil
        end

      %{
        frobot: frobot,
        frobot_user_id: user_id,
        frobot_id: frobot_id,
        id: id,
        match_id: match_id,
        slot_type: slot_type,
        status: status
      }
    end)
  end
end
