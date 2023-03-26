defmodule FrobotsWeb.GarageFrobotCreateLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Assets
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(_params, %{"user_id" => id}, socket) do
    # set required data via assigns
    current_user = Accounts.get_user!(id)
    {:ok, socket |> assign(:current_user, current_user)}
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
  def handle_event("react.fetch_frobot_create_details", _params, socket) do
    templates = Assets.list_template_frobots()

    {:noreply,
     push_event(socket, "react.return_frobot_create_details", %{
       "templates" => templates
     })}
  end

  def handle_event("react.create_frobot", params, socket) do
    current_user = socket.assigns.current_user

    case Assets.create_frobot(current_user, params) do
      {:ok, frobot} ->
        {:noreply,
         socket
         |> push_redirect(to: "/garage/frobot?id=#{frobot.id}")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not create frobot")}
    end
  end
end
