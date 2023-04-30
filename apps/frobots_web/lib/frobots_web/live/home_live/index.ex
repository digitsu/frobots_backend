defmodule FrobotsWeb.HomeLive.Index do
  use FrobotsWeb, :live_view
  alias Frobots.{UserStats, GlobalStats, Api}
  alias Frobots.{Accounts, Assets, Events}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    s3_base_url = Api.get_s3_base_url()

    # gets battlelogs info and stores in agent for further processing for player and leaderboard entries
    # this data should really come from db
    # Events.prep_leaderboard_entries()

    {:ok,
     socket
     |> assign(:username, get_user_name(current_user))
     |> assign(:frobots, Assets.list_user_frobots(current_user))
     |> assign(:current_user, current_user)
     |> assign(:featured_frobots, Assets.list_template_frobots())
     |> assign(:current_user_stats, UserStats.get_user_stats(current_user))
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )
     |> assign(:blog_posts, get_blog_posts())
     |> assign(:global_stats, GlobalStats.get_global_stats(current_user))
     |> assign(:frobot_leaderboard_stats, Events.send_leaderboard_entries())
     |> assign(:player_leaderboard_stats, Events.send_player_leaderboard_entries())
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
  def handle_event("react.fetch_dashboard_details", _params, socket) do
    currentUserStatus = socket.assigns.current_user_stats
    current_user = socket.assigns.current_user

    {:noreply,
     push_event(socket, "react.return_dashboard_details", %{
       "current_user_name" => socket.assigns.username,
       "current_user_avatar" => current_user.avatar,
       "current_user_sparks" => current_user.sparks,
       "current_user_ranking_details" => socket.assigns.current_user_ranking_details,
       "frobot_leaderboard_stats" => socket.assigns.frobot_leaderboard_stats,
       "player_leaderboard_stats" => socket.assigns.player_leaderboard_stats,
       "globalStats" => socket.assigns.global_stats,
       "blogPosts" => socket.assigns.blog_posts,
       "featuredFrobots" => extract_frobots(socket.assigns.featured_frobots),
       "playerStats" => %{
         "frobots_count" => currentUserStatus.frobots_count,
         "matches_participated" => currentUserStatus.matches_participated,
         "total_xp" => currentUserStatus.total_xp,
         "upcoming_matches" => currentUserStatus.upcoming_matches
       },
       "s3_base_url" => socket.assigns.s3_base_url
     })}
  end

  def get_user_name(current_user) do
    current_user.name || List.first(String.split(current_user.email, "@"))
  end

  def extract_frobots(frobots) do
    Enum.map(
      frobots,
      fn %{
           id: id,
           name: name,
           class: class,
           xp: xp,
           avatar: avatar,
           bio: bio,
           pixellated_img: pixellated_img,
           user_id: user_id,
           inserted_at: inserted_at,
           updated_at: updated_at
         } ->
        %{
          id: id,
          name: name,
          class: class,
          xp: xp,
          avatar: avatar,
          bio: bio,
          pixellated_img: pixellated_img,
          user_id: user_id,
          inserted_at: inserted_at,
          updated_at: updated_at
        }
      end
    )
  end
end
