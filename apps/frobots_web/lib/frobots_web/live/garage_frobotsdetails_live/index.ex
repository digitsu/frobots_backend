defmodule FrobotsWeb.GarageFrobotsDetailsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Assets, Api}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:user_frobots, Assets.list_user_frobots(current_user))}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("react.fetch_frobot_details", params, socket) do
    # find the frobot in the list which you are looking for in params.frobot_name
    # frobot = Enum.find(socket.assigns.user_frobots, nil, fn f -> f.name == params.frobot_name end)
    case Api.get_frobot_details(params.frobot_name) do
      {:ok, frobot_details} ->
        {:noreply,
         push_event(socket, "react.return_frobot_details", %{
           "frobot_details" => frobot_details
         })}

      {:error, message} ->
        {:noreply,
         push_event(socket, "react.return_frobot_details", %{
           "error" => message
         })}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
