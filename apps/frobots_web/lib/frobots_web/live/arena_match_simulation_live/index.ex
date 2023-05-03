defmodule FrobotsWeb.ArenaMatchSimulationLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.Api
  alias PhoenixClient.{Socket, Channel}

  @impl Phoenix.LiveView
  def mount(
        %{"match_id" => match_id} = _params,
        %{"user_id" => id, "user_token" => _user_token},
        socket
      ) do
    match = Api.get_match_details_by_id(match_id)
    arenas = Api.list_arena()
    s3_base_url = Api.get_s3_base_url()

    arena = Enum.find(arenas, fn %{id: arena_id} -> arena_id == match.arena_id end)

    match_channel =
      if connected?(socket) do
        topic = "match:match#{match_id}"
        IO.inspect("SUBSCRIBING TO #{topic}")
        Phoenix.PubSub.subscribe(Frobots.PubSub, topic)
        # socket_opts = Application.get_env(:phoenix_client, :socket)
        # {:ok, phoenix_socket} = Socket.start_link(socket_opts)
        # wait_for_socket(phoenix_socket)
        # {:ok, _response, match_channel} = Channel.join(phoenix_socket, "match:" <> match_id)
        # wait_for_socket(phoenix_socket)

        # match_channel |> IO.inspect(label: "Match Channel INSIDE CONNECTED")
      end

    {:ok,
     socket
     |> assign(:match_channel, match_channel)
     |> assign(:match, match)
     |> assign(:arena, arena)
     |> assign(:match_id, match_id)
     |> assign(:user_id, id)
     |> assign(:s3_base_url, s3_base_url)}
  end

  def handle_event("react.fetch_match_details", %{}, socket) do
    %{match: match, user_id: user_id, s3_base_url: s3_base_url} = socket.assigns

    {:noreply,
     push_event(socket, "react.return_match_details", %{
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
       "s3_base_url" => s3_base_url
     })}
  end

  def handle_event("start_match", _params, socket) do
    match_id = socket.assigns.match_id |> String.to_integer()

    case FrobotsWeb.MatchChannel.start_match(match_id) do
      {:ok, _frobots_map} -> {:noreply, socket}
      {:error, error} -> {:noreply, socket |> put_flash(:error, error)}
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

    # IO.inspect(match)
    matchDetails = %{
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
     |> push_event(:match, %{
       id: assigns.match_id,
       match_details: matchDetails,
       s3_base_url: s3_base_url,
       arena: arena
     })}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
  def handle_info({:create_tank, _frobot, _loc} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:move_tank, frobot, loc, heading, speed} = msg, socket) do
    {:noreply,
     socket
     |> push_event(:arena_event, encode_event(msg))}
  end

  @impl true
  def handle_info({:kill_tank, _frobot} = msg, socket) do
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

  defp wait_for_socket(socket) do
    unless Socket.connected?(socket) do
      wait_for_socket(socket)
    end
  end
end
