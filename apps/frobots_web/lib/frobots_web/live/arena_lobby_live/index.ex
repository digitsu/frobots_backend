defmodule FrobotsWeb.ArenaLobbyLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Api, Events}

  @impl Phoenix.LiveView
  def mount(%{"match_id" => match_id} = _params, _session, socket) do
    match = Api.get_match_details_by_id(match_id)

    if is_nil(match) do
      {:noreply, put_flash(socket, :error, "invalid match id")}
    else
      if connected?(socket), do: Events.subscribe()
      {:ok, socket |> assign(:match, match)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event(event, %{"slot_id" => slot_id}, socket)
      when event in ["joining", "ready", "closed"] do
    match = socket.assigns.match

    case Api.update_slot(match.id, slot_id, %{status: event}) do
      {:ok, updated_slot} ->
        updated_slots =
          Enum.reduce(match.slots |> Enum.reverse(), [], fn slot, acc ->
            if slot.id == updated_slot.id do
              [Map.put(slot, :status, updated_slot.status) | acc]
            else
              [slot | acc]
            end
          end)

        updated_match = Map.put(match, :slots, updated_slots)
        {:noreply, socket |> assign(:match, updated_match)}

      {:error, :slot_not_found} ->
        {:noreply, put_flash(socket, :error, "invalid slot id")}

      {:error, changeset} ->
        {:noreply, assign(socket, match_changeset: changeset)}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({Events, [:slot, :updated], updated_slot}, socket) do
    match = socket.assigns.match

    updated_slots =
      Enum.reduce(match.slots |> Enum.reverse(), [], fn slot, acc ->
        if slot.id == updated_slot.id do
          [Map.put(slot, :status, updated_slot.status) | acc]
        else
          [slot | acc]
        end
      end)

    updated_match = Map.put(match, :slots, updated_slots)
    {:noreply, socket |> assign(:match, updated_match)}
  end
end
