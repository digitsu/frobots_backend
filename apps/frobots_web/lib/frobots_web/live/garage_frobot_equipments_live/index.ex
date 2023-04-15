defmodule FrobotsWeb.GarageFrobotEquipmentsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.{Assets, Accounts, Equipment}

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    # set required data via assigns
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    frobot_id = params["frobot_id"]
    # equipment_id = params["id"]

    # Get the current frobot
    current_frobot = Assets.get_user_frobot!(current_user, frobot_id)
    # Get the current xframe for the frobot
    current_xframe = Equipment.get_current_xframe(current_frobot)
    # get all the frobots beloning to this user
    user_frobots = Assets.list_user_frobots(current_user)
    # get all the equipments attached to this frobot
    attached_equipments = Equipment.list_frobot_equipment(frobot_id)
    # get all the equipments owned by current user
    user_equipment_inventory = Equipment.list_user_equipment(session["user_id"])
    # # This can be improved based on the frobot selected
    # equipment_inventory = Equipment.get_all()

    {:ok,
     socket
     |> assign(:user, current_user)
     |> assign(:user_frobots, user_frobots)
     |> assign(:current_frobot, current_frobot)
     |> assign(:current_xframe, current_xframe)
     |> assign(:attached_equipments, attached_equipments)
     # |> assign(:equipment_inventory, equipment_inventory)
     |> assign(:user_equipment_inventory, user_equipment_inventory)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_event("react.fetch_frobot_equipments_details", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_frobot_equipments_details", %{
       "currentUser" => "currentUser",
       "frobotList" => "extract_frobots(socket.assigns.user_frobots)"
     })}
  end
end
