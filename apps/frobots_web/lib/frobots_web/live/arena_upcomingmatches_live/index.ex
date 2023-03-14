defmodule FrobotsWeb.ArenaUpcomingMatchesLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

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
end
