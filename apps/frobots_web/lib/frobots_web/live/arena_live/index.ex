defmodule FrobotsWeb.ArenaLive.Index do
  use FrobotsWeb, :live_view

  @impl Phoenix.LiveView
  @spec mount(any, nil | maybe_improper_list | map, map) :: {:ok, map}
  def mount(_params, _session, socket) do
    # current_user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok,socket}
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
