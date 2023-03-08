defmodule FrobotsWeb.HomeLive.Index do
  use FrobotsWeb, :live_view
  alias Frobots.Accounts
  alias Frobots.Assets

  @impl Phoenix.LiveView
  @spec mount(any, nil | maybe_improper_list | map, map) :: {:ok, map}
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    # get list of fronots and show
    frobots = Assets.list_user_frobots(current_user)

    IO.inspect(show_global_stats())

    {:ok,
     socket
     |> assign(:frobots, frobots)
     |> assign(:featured_frobots, get_featured_frobots())
     |> assign(:current_user_stats, Assets.get_user_stats(current_user))
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
    base_path = Path.join(:code.priv_dir(:frobots_web), "/static/images/")

    [
      %{
        "name" => "X-tron",
        "xp" => "65700 xp",
        "image_path" => base_path <> "/featured_one.png"
      },
      %{
        "name" => "New Horizon",
        "xp" => "65700 xp",
        "image_path" => base_path <> "/featured_two.png"
      },
      %{
        "name" => "Golden Rainbow",
        "xp" => "65700 xp",
        "image_path" => base_path <> "/featured_three.png"
      },
      %{
        "name" => "Steel Bully",
        "xp" => "65700 xp",
        "image_path" => base_path <> "/featured_four.png"
      }
    ]
  end

  def show_global_stats() do
    %{
      "players_online" => 250,
      "matches_in_progress" => 65,
      "players_registered" => 1500,
      "matches_completed" => 376
    }
  end
end
