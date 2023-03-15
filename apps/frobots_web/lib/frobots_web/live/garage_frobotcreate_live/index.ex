defmodule FrobotsWeb.GarageFrobotCreateLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Assets

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # set required data via assigns
    {:ok, socket}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl true
  def handle_event("react.fetch_frobot_create_details", _params, socket) do
    templates = Assets.list_template_frobots()

    {:noreply,
     push_event(socket, "react.return_frobot_create_details", %{
       "templates" => templates
     })}
  end
end
