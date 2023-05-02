defmodule FrobotsWeb.NewsAndUpdatesLive.Index do
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Events}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )
     |> assign(:blog_posts, get_blog_posts())}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  def get_blog_posts() do
    with {:ok, url} <- Application.fetch_env(:frobots_web, :ghost_blog_url),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, data} <- Jason.decode(body) do
      data["posts"]
    else
      {:ok, _} ->
        IO.puts("Something other than HTTP 200 returned")
        []

      {:error, err} ->
        IO.puts("GhostBlog: no data posts! Err: " <> IO.inspect(err))
        []

      :error ->
        IO.puts("GhostBlog: No Ghost URL!")
        []
    end
  end

  @impl true
  def handle_event("react.fetch_news_and_updates", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_news_and_updates", %{
       "blogPosts" => socket.assigns.blog_posts
     })}
  end
end
