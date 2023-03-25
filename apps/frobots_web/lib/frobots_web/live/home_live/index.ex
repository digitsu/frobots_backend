defmodule FrobotsWeb.HomeLive.Index do
  use FrobotsWeb, :live_view
  require Logger
  alias Frobots.UserStats
  alias Frobots.Accounts
  alias Frobots.Assets

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    # get list of frobots and show

    {:ok,
     socket
     |> assign(:frobots, Assets.list_user_frobots(current_user))
     |> assign(:featured_frobots, get_featured_frobots())
     |> assign(:current_user_stats, UserStats.get_user_stats(current_user))
     |> assign(:blog_posts, get_blog_posts())
     |> assign(:global_stats, show_global_stats())}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp get_featured_frobots() do
    [
      %{
        "id" => 1,
        "name" => "X-tron",
        "xp" => "65700 xp",
        "image_path" => "/images/frobot1.png"
      },
      %{
        "id" => 2,
        "name" => "New Horizon",
        "xp" => "65700 xp",
        "image_path" => "/images/frobot2.png"
      },
      %{
        "id" => 3,
        "name" => "Golden Rainbow",
        "xp" => "65700 xp",
        "image_path" => "/images/frobot3.png"
      },
      %{
        "id" => 4,
        "name" => "Steel Bully",
        "xp" => "65700 xp",
        "image_path" => "/images/frobot4.png"
      }
    ]
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
        IO.puts("GhostBlog: no data posts! Err: " <> err)
        []

      :error ->
        IO.puts("GhostBlog: No Ghost URL!")
        []
    end
  end

  def show_global_stats() do
    %{
      "players_online" => 250,
      "matches_in_progress" => 65,
      "players_registered" => 1500,
      "matches_completed" => 376
    }
  end

  @impl true
  def handle_event("react.fetch_dashboard_details", _params, socket) do
    currentUserStatus = socket.assigns.current_user_stats

    {:noreply,
     push_event(socket, "react.return_dashboard_details", %{
       "globalStats" => show_global_stats(),
       "blogPosts" => socket.assigns.blog_posts,
       "featuredFrobots" => socket.assigns.featured_frobots,
       "playerStats" => %{
         "frobots_count" => currentUserStatus.frobots_count,
         "matches_participated" => currentUserStatus.matches_participated,
         "total_xp" => currentUserStatus.total_xp,
         "upcoming_matches" => currentUserStatus.upcoming_matches
       }
     })}
  end
end
