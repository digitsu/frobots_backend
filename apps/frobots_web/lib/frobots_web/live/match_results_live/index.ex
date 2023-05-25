defmodule FrobotsWeb.MatchResultsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Events, Api}

  @impl Phoenix.LiveView
  def mount(%{"match_id" => match_id} = _params, _session, socket) do
    match_results =
      Events.get_match_details(String.to_integer(match_id))

    match = Api.get_match_details_by_id(match_id)
    {:ok, socket |> assign(:match_results, match_results) |> assign(:match, match)}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("react.fetch_arena_match_results", %{}, socket) do
    base_url = Api.get_s3_base_url()

    {:noreply,
     push_event(socket, "react.return_match_results", %{
       "match_results" => socket.assigns.match_results,
       "s3_base_Url" => base_url
     })}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
