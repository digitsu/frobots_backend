defmodule FrobotsWeb.HomeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Accounts
  alias Frobots.Assets

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    # current_user = Accounts.get_user!(session["user_id"])
    # set required data via assigns
    # for example..fetch leaderboard entries and pass to liveview as follow
    # get list of fronots and show
    frobots = Assets.list_user_frobots(current_user)
    {:ok, socket |> assign(:frobots, frobots)}
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
