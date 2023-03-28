defmodule FrobotsWeb.ArenaLobbyLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Api, Events}

  @impl Phoenix.LiveView
  def mount(%{"match_id" => match_id} = params, _session, socket) do
    match = Api.get_match_details_by_id(match_id)

    if is_nil(match) do
      {:noreply, put_flash(socket, :error, "invalid match id")}
    else
      if connected?(socket), do: Events.subscribe()
      {:ok, socket |> assign(:match, match)}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end
end
