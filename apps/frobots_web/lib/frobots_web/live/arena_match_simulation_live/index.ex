defmodule FrobotsWeb.ArenaMatchSimulationLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Api, Events}
  alias PhoenixClient.{Socket, Channel}
  alias FrobotsWeb.Simulator

  @impl Phoenix.LiveView
  def mount(
        %{"match_id" => match_id} = _params,
        %{"user_id" => id, "user_token" => user_token},
        socket
      ) do
    match = Api.get_match_details_by_id(match_id)
    arenas = Api.list_arena()
    s3_base_url = Api.get_s3_base_url()

    arena = Enum.find(arenas, fn %{id: arena_id} -> arena_id == match.arena_id end)

    simulator =
      case Simulator.start_link([]) do
        {:ok, simulator} -> simulator
        {:error, {:already_started, simulator}} -> simulator
      end

    {:ok,
     socket
     |> assign(:simulator, simulator)
     |> assign(:match, match)
     |> assign(:arena, arena)
     |> assign(:match_id, match_id)
     |> assign(:user_id, id)
     |> assign(:match, match)
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

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  def handle_event("start_match", _params, socket) do
    match_id = socket.assigns.match_id
    socket_opts = Application.get_env(:phoenix_client, :socket)

    {:ok, phoenix_socket} = Socket.start_link(socket_opts)
    wait_for_socket(phoenix_socket)

    {:ok, _response, match_channel} = Channel.join(phoenix_socket, "match:" <> match_id)


    wait_for_socket(phoenix_socket)

    case Channel.push(match_channel, "start_match", %{"id" => String.to_integer(match_id)}) do
      {:ok, _frobots_map} ->
        ## Redirect to a page where they are listing to the channel for events
        {:noreply, socket |> assign(:match_channel, match_channel)}

      {:error, error} ->
        {:noreply, socket |> assign(:match_channel, match_channel) |> put_flash(:error, error)}
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
    #     socket_opts = Application.get_env(:phoenix_client, :socket)

    # {:ok, phoenix_socket} = Socket.start_link(socket_opts)
    # wait_for_socket(phoenix_socket)
    # {:ok, _response, match_channel} = Channel.join(phoenix_socket, "match:" <>  assigns.match_id)


    # IO.inspect(matchDetails)
    # {:ok, match_id} = Simulator.start_match(assigns.simulator)

    {:noreply,
     socket
     |> push_event(:match, %{
       id: assigns.match_id,
       match_details: matchDetails,
       s3_base_url: s3_base_url,
       arena: arena
     })}
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

  # defp extract_slot_details_from_match(slots) do
  #   Enum.map(slots, fn %{
  #                        frobot: frobot,
  #                        frobot_id: frobot_id,
  #                        id: id,
  #                        match_id: match_id,
  #                        slot_type: slot_type,
  #                        status: status,
  #                        inserted_at: inserted_at                     } ->
  #     user_id =
  #       if frobot do
  #         Map.get(frobot, :user_id, nil)
  #       else
  #         nil
  #       end

  #     %{
  #       frobot: frobot,
  #       frobot_user_id: user_id,
  #       frobot_id: frobot_id,
  #       id: id,
  #       match_id: match_id,
  #       slot_type: slot_type,
  #       status: status,
  #       pixellated_img: inserted_at
  #     }
  #   end)
  # end

  ## TODO remove
  # def handle_event("start_match", _params, socket) do
  #   match_id = socket.assigns.match_id
  #   socket_opts = Application.get_env(:phoenix_client, :socket)
  #   {:ok, phoenix_socket} = Socket.start_link(socket_opts)
  #   wait_for_socket(phoenix_socket)

  #   {:ok, _response, match_channel} = Channel.join(phoenix_socket, "match:" <> match_id)

  #   wait_for_socket(phoenix_socket)

  #   case Channel.push(match_channel, "start_match", %{"id" => String.to_integer(match_id)}) do
  #     {:ok, _frobots_map} ->
  #       ## Redirect to a page where they are listing to the channel for events
  #       {:noreply, socket |> assign(:match_channel, match_channel)}

  #     {:error, error} ->
  #       {:noreply, socket |> assign(:match_channel, match_channel) |> put_flash(:error, error)}
  #   end
  # end

  ## To connect to socket

  # @impl Phoenix.LiveView
  # def handle_event("load_simulater", _value, socket) do
  #   ## push event to simulater
  #   assigns = socket.assigns()
  #   IO.inspect("MATCH FROM LOAD")
  #       # match = Api.get_match_details_by_id(assigns.match_id)
  #       match_id=assigns.match_id

  #   # # IO.inspect(match)
  #   #     matchDetails = %{
  #   #   "arena_id" => match.arena_id,
  #   #   "match_time" => match.match_time,
  #   #   "slots" => match.slots,
  #   #   "title" => match.title,
  #   #   "type" => match.type,
  #   #   "status" => match.status,
  #   #   "frobots" =>match.frobots
  #   # }
  #   # IO.inspect(matchDetails)
  #   # assigns = socket.assigns()
  #   # {:ok} = Simulator.request_match(assigns.simulator)
  #       # {:ok, match_id} = Simulator.request_match(assigns.simulator)
  #   {:noreply, socket |> push_event(:match, %{id: match_id})}
  # end

  ## Ends
end
