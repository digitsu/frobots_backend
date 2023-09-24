defmodule FrobotsWeb.TournamentCreateLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Api
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(_params, %{"user_id" => id}, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user!(id)
    s3_base_url = Api.get_s3_base_url()

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:s3_base_url, s3_base_url)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  def handle_event("react.fetch_create_tournament_details", _params, socket) do
    arenas = Api.list_arena()

    {:noreply,
     push_event(socket, "react.return_create_tournament_details", %{
       "s3_base_url" => socket.assigns.s3_base_url,
       "arenas" => arenas
     })}
  end

  @impl Phoenix.LiveView
  def handle_event("react.create_tournament", params, socket) do
    case Api.create_tournament(params) do
      {:ok, tournament} ->
        {:noreply,
         socket
         |> assign(:tournament_id, tournament.id)}

      {:error, error} ->
        {:noreply,
         socket
         |> assign(:errors, error)
         |> put_flash(:error, "Could not create tournament. #{error}")}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("react.join_tournament", _params, socket) do
    # Api.join_tournament(params)
    {:noreply, socket}
  end
end
