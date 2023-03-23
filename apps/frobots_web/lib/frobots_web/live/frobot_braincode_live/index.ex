defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Assets}

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    frobot_id = params["id"]

    case Assets.get_frobot(String.to_integer(frobot_id)) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Not found any frobot with id #{frobot_id}")
         |> push_redirect(to: "/garage")}

      frobot ->
        {:ok,
         socket
         |> assign(:frobot, frobot)}
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

  def handle_event("react.fetch_bot_braincode", socket) do
    frobot = socket.assigns.frobot

    frobotDetails = %{
      "frobot_id" => frobot.id,
      "name" => frobot.name,
      "avatar" => frobot.avatar,
      "blockly_code" => frobot.blockly_code,
      "brain_code" => frobot.brain_code,
      "class" => frobot.class,
      "xp" => frobot.xp
    }

    {:noreply, push_event(socket, "react.return_bot_braincode", %{"frobot" => frobotDetails})}
  end
end
