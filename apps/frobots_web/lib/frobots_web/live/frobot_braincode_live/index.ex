defmodule FrobotsWeb.FrobotBraincodeLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

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

  @impl Phoenix.LiveView
  def handle_event("react.fetch_bot_braincode", _params, socket) do
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

  def handle_event("react.update_bot_braincode", params, socket) do
    frobot_id = params["frobot_id"]
    brain_code = params["brain_code"]

    if brain_code === "" || is_nil(brain_code) || String.trim(brain_code) === "" do
      {:noreply, socket |> put_flash(:error, "Brain code can not be empty")}
    else
      frobot = Assets.get_frobot!(frobot_id)

      case Assets.update_frobot(frobot, params) do
        {:ok, updatedFrobot} ->
          frobotDetails = %{
            "frobot_id" => updatedFrobot.id,
            "name" => updatedFrobot.name,
            "avatar" => updatedFrobot.avatar,
            "blockly_code" => updatedFrobot.blockly_code,
            "brain_code" => updatedFrobot.brain_code,
            "class" => updatedFrobot.class,
            "xp" => updatedFrobot.xp
          }

          {:noreply,
           push_event(
             socket
             |> assign(:frobot, updatedFrobot)
             |> put_flash(:info, "frobot updated successfully"),
             "react.update_bot_braincode",
             %{"frobot" => frobotDetails}
           )}

        {:_error, changeset} ->
          Logger.error("Error while updating brain code #{inspect(changeset)}")
          {:noreply, socket |> put_flash(:error, "Error while updating brain code")}
      end
    end
  end
end
