defmodule FrobotsWeb.Api.EventsController do
  use FrobotsWeb, :controller
  alias Frobots.Events
  alias Frobots.Events.Match

  action_fallback FrobotsWeb.FallbackController

  def change(conn, _params) do
    %{"id" => match_id} = conn.params
    attrs = conn.body_params
    case Events.get_match_by([id: match_id]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json([])
        |> halt()
      match ->
        {:ok, updated_match} = Events.change_match(match, attrs)

        conn
        |> put_status(200)
        |> json(updated_match)
    end
  end

  def start_match(conn, _params) do
    %{"id" => match_id} = conn.params
    case Events.get_match_by([id: match_id],
           slots: [
             frobot: [
               cpu_inst: :cpu,
               xframe_inst: :xframe,
               cannon_inst: :cannon,
               scanner_inst: :scanner,
               missile_inst: :missile
             ]
           ]
         ) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json([])
        |> halt()

      match = %Match{} ->
        _frobots =
          Enum.reduce(match.slots, [], fn slot, acc ->
            if slot.status == :ready do
              [Map.get(slot, :frobot) |> Map.from_struct() |> Map.put(:slot_id, slot.id) | acc]
            else
              acc
            end
          end)

        opponent_frobot? =
          Enum.any?(match.slots, fn slot ->
            slot.status == :ready and slot.slot_type == :player
          end)

        attrs = if opponent_frobot?, do: %{type: :real}, else: %{type: :simulation}
        {:ok, updated_match} = Events.change_match(match, attrs)

        conn |> put_status(200) |> json(updated_match)
    end
  end
end
