defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  alias Frobots.{Assets}

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # set required data via assigns
    # for example..fetch leaderboard entries and pass to liveview as follow
    {:ok, socket}
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
  def handle_event("react.fetch_bot_braincode", %{"frobot_id" => frobot_id}, socket) do
    case Assets.get_frobot(frobot_id) do
      nil ->
        {:noreply, push_event(socket, "react.return_bot_braincode", %{"frobot" => nil})}

      frobot ->
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
end
