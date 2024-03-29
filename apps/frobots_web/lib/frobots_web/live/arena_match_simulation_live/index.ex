defmodule FrobotsWeb.ArenaMatchSimulationLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger
  alias Frobots.Api
  alias Frobots.Events

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
      {:ok, socket |> push_redirect(to: "/arena/#{match_id}/results")}
    end

    snapshot =
      if connected?(socket) do
        Events.subscribe()
        topic = "match:match#{match_id}"
        Logger.info("SUBSCRIBING TO #{topic}")
        Phoenix.PubSub.subscribe(Frobots.PubSub, topic)

        ## GET SNAPSHOT EVENT
        if match.status == :running do
          arena_name = Fubars.Match.arena_name(match_id |> to_string())
          arena = Fubars.via_tuple(arena_name)
          arena_state = Fubars.Arena.get_state(arena)

          _snapshot = %{
            missile: arena_state.missile,
            rig:
              Enum.map(arena_state.rig, fn {rig_name, _} ->
                {:ok, rig} =
                  Fubars.Registry.lookup(
                    Fubars.via_tuple(arena_state.rig_registry_name),
                    rig_name,
                    :rig
                  )

                Fubars.Rigs.get_state(rig)
                |> Map.from_struct()
                |> Map.take([:curr_loc, :health, :status, :name, :max_health, :heading, :speed])
              end) ++
                (arena_state.death_map
                 |> Enum.map(fn {name, _} -> %{status: :disabled, name: name} end))
          }
        end
      end

    time_left =
      if match.status == :running do
        Process.send_after(self(), :time_left, 1_000)
        match.timer - (System.os_time(:second) - match.started_at)
      end

    {:ok,
     socket
     |> assign(:time_left, time_left)
     |> assign(:match, match)
     |> assign(:arena, arena)
     |> assign(:match_id, match_id)
     |> assign(:user_id, id)
     |> assign(:s3_base_url, s3_base_url)
     |> assign(:background_audio, "#{s3_base_url}#{battle_bg_audio}")
     |> assign(:snapshot, snapshot)}
  end

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
       "is_replay" => false
     })}
  end

  def handle_event("start_match", _params, socket) do
    match_id = socket.assigns.match_id |> String.to_integer()

    case FrobotsWeb.MatchChannel.start_match(match_id) do
      {:ok, _frobots_map} ->
        match = Api.get_match_details_by_id(match_id)

        time_left =
          if match.status == :running do
            Process.send_after(self(), :time_left, 1_000)
            match.timer - (System.os_time(:second) - match.started_at)
          end

        {:noreply, socket |> assign(:time_left, time_left)}

      {:error, error} ->
        {:noreply, socket |> put_flash(:error, error)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("load_simulater", _value, socket) do
    ## push event to simulater
    assigns = socket.assigns()
    # match = Api.get_match_details_by_id(assigns.match_id)
    match = assigns.match
    arena = assigns.arena
    s3_base_url = assigns.s3_base_url
    background_audio = assigns.background_audio

    # Logger.info(match)
    match_details = %{
      "arena_id" => match.arena_id,
      "match_time" => match.match_time,
      "slots" => match.slots,
      "title" => match.title,
      "type" => match.type,
      "status" => match.status,
      "frobots" => match.frobots
    }

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

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl Phoenix.LiveView
  def handle_info({Events, [:match, :updated], updated_match}, socket) do
    match_id = socket.assigns.match_id

    if updated_match.id == match_id and updated_match.status == :running do
      ## REDIRECT
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:fsm_state, _frobot, _fsm_state} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:fsm_debug, _frobot, _fsm_state} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:scan, _frobot, _deg, _res} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:damage, _frobot, _damage} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:create_rig, _frobot, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:move_rig, _frobot, _loc, _heading, _speed} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:kill_rig, _frobot} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:create_miss, _m_name, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:move_miss, _m_name, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:kill_miss, _m_name} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:game_over, _winners} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info(:time_left, socket) do
    time_left =
      if not is_nil(socket.assigns.time_left) and socket.assigns.time_left > 0 do
        socket.assigns.time_left - 1
      end

    Process.send_after(self(), :time_left, 1_000)
    {:noreply, socket |> assign(:time_left, time_left)}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  def encode_event(evt_tuple) do
    [evt | args] = Tuple.to_list(evt_tuple)
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

  defp apply_action(socket, :index, _params) do
    # entries = Frobots.LeaderBoard.get()
    # {:ok,socket
    # |> assign(:entries, entries)
    # }

    #  socket
    # |> assign_new(:rider_search, fn -> rider_search end)
    socket
  end

  @spec seconds_to_hh_mm_ss(integer | nil | float) :: String.t()
  def seconds_to_hh_mm_ss(value) when is_integer(value) or is_nil(value) do
    case value do
      nil ->
        "00:00:00"

      integer_value when is_integer(integer_value) ->
        hours = div(integer_value, 3600)
        remaining_seconds = rem(integer_value, 3600)
        minutes = div(remaining_seconds, 60)
        seconds = rem(remaining_seconds, 60)

        formatted_hours = Integer.to_string(hours)
        formatted_minutes = Integer.to_string(minutes)
        formatted_seconds = Integer.to_string(seconds)

        formatted_hours = String.pad_leading(formatted_hours, 2, "0")
        formatted_minutes = String.pad_leading(formatted_minutes, 2, "0")
        formatted_seconds = String.pad_leading(formatted_seconds, 2, "0")

        "#{formatted_hours}:#{formatted_minutes}:#{formatted_seconds}"
    end
  end
end
