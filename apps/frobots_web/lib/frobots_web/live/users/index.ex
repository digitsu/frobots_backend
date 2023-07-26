defmodule FrobotsWeb.UsersLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Accounts.User
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    FrobotsWeb.Presence.track(socket)
    users = Accounts.list_users()
    {:ok, socket |> assign(:users, users)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:user, %User{})
  end
end
