defmodule FrobotsWeb.GarageFrobotsDetailsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Assets, Api, Events}

  require Logger

  @impl Phoenix.LiveView
  def mount(%{"id" => frobot_id} = _params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    # If frobot_id is missing in the url redirect user to garage
    if frobot_id === "" do
      {:ok,
       socket
       |> put_flash(:error, "Frobot id not specified in the url")
       |> push_redirect(to: "/garage")}
    end

    case Api.get_frobot_details(String.to_integer(frobot_id)) do
      {:ok, frobot_details} ->
        {:ok,
         socket
         |> assign(:user, current_user)
         |> assign(
           :current_user_ranking_details,
           Events.get_current_user_ranking_details(current_user)
         )
         |> assign(:frobot, frobot_details)
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))}

      {:error, message} ->
        {:ok,
         socket
         |> put_flash(:error, message)
         |> push_redirect(to: "/garage")}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("react.fetch_frobot_details", _params, socket) do
    frobot = socket.assigns.frobot
    current_user = socket.assigns.user
    user_frobots = extract_frobots(socket.assigns.user_frobots)

    currentUser = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_frobot_details", %{
       "frobot" => frobot,
       "currentUser" => currentUser,
       "userFrobots" => user_frobots
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

  defp apply_action(socket, :index, _params) do
    socket
  end
end
