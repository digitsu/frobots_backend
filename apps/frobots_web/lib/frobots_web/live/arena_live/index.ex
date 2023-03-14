defmodule FrobotsWeb.ArenaLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # set required data via assigns
    # for example..fetch leaderboard entries and pass to liveview as follow
    {:ok, socket}
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
end
