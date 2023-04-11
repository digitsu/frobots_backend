defmodule FrobotsWeb.FrobotEquipmentBayLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Assets , Api}

    @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    IO.inspect(MOUNTSSS)
      IO.inspect(params)
    # set required data via assigns
    # for example..fetch leaderboard entries and pass to liveview as follow
    {:ok, socket}
  end

  # @impl Phoenix.LiveView
  # def mount(%{"id" => frobot_id} = _params, session, socket) do
  #   IO.inspect("MOUNTSSS")
  #     current_user = Accounts.get_user_by_session_token(session["user_token"])
  #   # If frobot_id is missing in the url redirect user to garage
  #   if frobot_id === "" do
  #     {:ok,
  #      socket
  #      |> put_flash(:error, "Frobot id not specified in the url")
  #      |> push_redirect(to: "/garage")}
  #   end

  #   case Api.get_frobot_details(String.to_integer(frobot_id)) do
  #     {:ok, frobot_details} ->

  #       {:ok,
  #        socket
  #        |> assign(:user, current_user)
  #        |> assign(:frobot, frobot_details)
  #        |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

  #     {:error, message} ->
  #       {:ok,
  #        socket
  #        |> put_flash(:error, message)
  #        |> push_redirect(to: "/garage")}
  #   end
  # end

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

  @impl true
  def handle_event("react.fetch_frobot_equipment_bay_details", _params, socket) do
    # frobot = socket.assigns.frobot
    # current_user = socket.assigns.user
    # user_frobots = extract_frobots(socket.assigns.user_frobots)

    IO.inspect("EQUIPMENT_BAY")
    # IO.inspect(frobot)
    # IO.inspect(current_user)
    # IO.inspect(user_frobots)

    # currentUser = %{
    #   "id" => current_user.id,
    #   "avatar" => current_user.avatar,
    #   "email" => current_user.email,
    #   "name" => current_user.name,
    #   "sparks" => current_user.sparks
    # }

    {:noreply,
     push_event(socket, "react.return_frobot_equipment_bay_details", %{
      #  "frobotDetails" => frobot,
      #  "currentUser" => currentUser,
      #  "userFrobots" => user_frobots,
     })}
  end

  @spec extract_frobots(any) :: list
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
end
