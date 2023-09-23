defmodule FrobotsWeb.NewsAndUpdatesLive.Index do
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Events}
  require Logger
  alias FrobotsWeb.Utils

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )
     |> assign(:blog_posts, Utils.get_blog_posts())}
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
  def handle_event("react.fetch_news_and_updates", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_news_and_updates", %{
       "blogPosts" => socket.assigns.blog_posts
     })}
  end
end
