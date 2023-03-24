defmodule FrobotsWeb.GarageFrobotsListLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Accounts, Assets}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:user_frobots, Assets.list_user_frobots(current_user))}
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
  def handle_event("react.fetch_user_frobots", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_user_frobots", %{
       "frobotList" => socket.assigns.user_frobots
     })}
  end
end
