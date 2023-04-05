defmodule FrobotsWeb.GarageFrobotsListLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Accounts, Assets, Events}

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
     |> assign(:user_frobots, Assets.list_user_frobots(current_user))}
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
  def handle_event("react.fetch_user_frobots", _params, socket) do
    current_user = socket.assigns.current_user

    currentUser = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_user_frobots", %{
       "currentUser" => currentUser,
       "frobotList" => extract_frobots(socket.assigns.user_frobots)
     })}
  end

  def extract_frobots(frobots) do
    Enum.map(
      frobots,
      fn %{
           id: id,
           name: name,
           brain_code: brain_code,
           class: class,
           xp: xp,
           blockly_code: blockly_code,
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
          brain_code: brain_code,
          class: class,
          xp: xp,
          blockly_code: blockly_code,
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
