defmodule FrobotsWeb.PlayerProfileLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Api, Assets, Leaderboard}

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    user_id = params["id"]

    if !user_id do
      {
        {:ok,
         socket
         |> put_flash(:error, "User id not specified in the url")
         |> push_redirect(to: "/home")}
      }
    end

    user = Accounts.get_user!(user_id)

    if !user do
      {
        {:ok,
         socket
         |> put_flash(:error, "User not found")
         |> push_redirect(to: "/home")}
      }
    else
      {:ok,
       socket
       |> assign(:user, user)
       |> assign(:username, get_user_name(user))
       |> assign(:player_status, Leaderboard.get_current_user_stats(user))
       |> assign(:user_frobots, Assets.list_user_frobots(user))
       |> assign(:s3_base_url, Api.get_s3_base_url())}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_event("react.get_player_profile", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_player_profile", %{
       "player_status" => socket.assigns.player_status,
       "s3_base_url" => socket.assigns.s3_base_url,
       "user" => destruct_user_details(socket.assigns.user),
       "user_name" => socket.assigns.username,
       "user_frobots" => extract_frobots(socket.assigns.user_frobots),
       "battle_logs" => []
     })}
  end

  def get_user_name(user) do
    user.name || List.first(String.split(user.email, "@"))
  end

  def destruct_user_details(user) do
    %{
      "active" => user.active,
      "admin" => user.admin,
      "avatar" => user.avatar,
      "email" => user.email,
      "id" => user.id,
      "name" => user.name,
      "sparks" => user.sparks,
      "inserted_at" => user.inserted_at
    }
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
