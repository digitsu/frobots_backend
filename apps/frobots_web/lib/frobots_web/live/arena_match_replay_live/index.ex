defmodule FrobotsWeb.ArenaMatchReplayLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger
  alias Frobots.Api

  @impl Phoenix.LiveView
  def mount(
        %{"match_id" => match_id} = _params,
        %{"user_id" => id, "user_token" => _user_token},
        socket
      ) do
    FrobotsWeb.Presence.track(socket)
    match = Api.get_match_details_by_id(match_id)
    arenas = Api.list_arena()
    s3_base_url = Api.get_s3_base_url()
    battle_bg_audio = Api.get_battle_background_audio()

    arena = Enum.find(arenas, fn %{id: arena_id} -> arena_id == match.arena_id end)

    if match.status == :done do
      Process.send_after(self(), :load_simulater, 500)

      {:ok,
       socket
       |> assign(:match, match)
       |> assign(:arena, arena)
       |> assign(:match_id, match_id)
       |> assign(:user_id, id)
       |> assign(:s3_base_url, s3_base_url)
       |> assign(:background_audio, "#{s3_base_url}#{battle_bg_audio}")
       |> assign(:snapshot, nil)
       |> assign(:parent, self())}
    else
      {:ok, socket |> put_flash(:error, "match is still not complete")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("react.fetch_match_details", %{}, socket) do
    %{
      match: match,
      user_id: user_id,
      s3_base_url: s3_base_url,
      background_audio: background_audio,
      arena: arena,
      snapshot: snapshot
    } = socket.assigns

    {:noreply,
     push_event(socket, "react.return_match_details", %{
       "match" => %{
         "id" => match.id,
         "slots" => extract_slot_details(match.slots),
         "description" => match.description,
         "title" => match.title,
         "timer" => match.timer,
         "type" => match.type,
         "max_player_frobot" => match.max_player_frobot,
         "min_player_frobot" => match.min_player_frobot,
         "match_time" => match.match_time,
         "status" => match.status
       },
       "user_id" => match.user_id,
       "current_user_id" => user_id,
       "s3_base_url" => s3_base_url,
       "battle_background_audio" => background_audio,
       "arena" => arena,
       "snapshot" => snapshot,
       "is_replay" => true
     })}
  end

  @impl true
  def handle_info(:load_simulater, socket) do
    assigns = socket.assigns()
    match = assigns.match
    arena = assigns.arena
    s3_base_url = assigns.s3_base_url
    background_audio = assigns.background_audio
    parent = assigns.parent

    match_details = %{
      "arena_id" => match.arena_id,
      "match_time" => match.match_time,
      "slots" => match.slots,
      "title" => match.title,
      "type" => match.type,
      "status" => match.status,
      "frobots" => match.frobots
    }

    Process.send_after(parent, :start_replay, 100)

    {:noreply,
     socket
     |> push_event(:arena_event, %{
       id: assigns.match_id,
       match_details: match_details,
       s3_base_url: s3_base_url,
       battle_background_audio: background_audio,
       arena: arena
     })}
  end

  @impl true
  def handle_info(:start_replay, socket) do
    assigns = socket.assigns()
    match_id = assigns.match.id
    parent = assigns.parent

    case Api.get_replay_events(match_id) do
      {:ok, events} ->
        spawn(fn ->
          Enum.each(events, fn event ->
            Process.send(parent, event, [])
            Process.sleep(15)
          end)
        end)

        {:noreply, socket}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "replay not supported for this match")}
    end
  end

  @impl true
  def handle_info(["fsm_state", _frobot, _fsm_state] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["fsm_debug", _frobot, _fsm_state] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["scan", _frobot, _deg, _res] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["damage", _frobot, _damage] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["create_rig", _frobot, _loc] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["move_rig", _frobot, _loc, _heading, _speed] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["kill_rig", _frobot] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["create_miss", _m_name, _loc] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["move_miss", _m_name, _loc] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["kill_miss", _m_name] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(["game_over", _winners] = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  def encode_event(event) do
    [evt | args] = event
    %{event: evt, args: args}
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
