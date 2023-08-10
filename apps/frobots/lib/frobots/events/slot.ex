defmodule Frobots.Events.Slot do
  @moduledoc """
  The Slot context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder, only: [:status, :match_id, :frobot_id, :slot_type, :match_type]}
  schema "slots" do
    field(:slot_type, Ecto.Enum, values: [:host, :protobot, :player])
    field(:status, Ecto.Enum, values: [:open, :closed, :joining, :ready, :done, :cancelled])
    field(:match_type, Ecto.Enum, values: [:simulation, :real], default: :real)
    belongs_to(:frobot, Frobot)
    belongs_to(:match, Match)
    timestamps()
  end

  @fields [:status]

  @doc false
  def changeset(slot, attrs) do
    slot
    |> cast(attrs, [:frobot_id, :match_id, :match_type])
    |> cast_assoc(:match)
    |> validate_slot_type(attrs)
    |> validate_status(attrs)
    |> validate_required(@fields)
    |> unique_constraint(:frobot_id,
      name: :unique_frobot_id_slot,
      message: "is already used in a match"
    )
  end

  @doc false
  def update_changeset(slot, attrs) do
    slot
    |> cast(attrs, [:frobot_id])
    |> validate_slot_type(attrs)
    |> validate_status(attrs)
    |> unique_constraint(:frobot_id,
      name: :unique_frobot_id_slot,
      message: "is already used in a match"
    )
  end

  defp validate_status(%Ecto.Changeset{valid?: true} = changeset, attrs) do
    new_status = (attrs["status"] || Map.get(attrs, :status)) |> to_atom()
    old_status = Map.get(changeset.data, :status, nil)

    if new_status do
      case validate_status_fsm(old_status, new_status) do
        true ->
          changeset
          |> cast(%{status: new_status}, [:status])

        false ->
          add_error(
            changeset,
            :status,
            "unable to update the slot status from #{old_status} to #{new_status}"
          )
      end
    else
      changeset
    end
  end

  defp validate_status(changeset, _attrs), do: changeset

  ## state creation of slot
  defp validate_status_fsm(nil, :ready), do: true
  defp validate_status_fsm(nil, :joining), do: true
  defp validate_status_fsm(nil, :open), do: true
  defp validate_status_fsm(nil, :closed), do: true

  ## update states
  defp validate_status_fsm(:open, :open), do: true
  defp validate_status_fsm(:open, :ready), do: true
  defp validate_status_fsm(:open, :joining), do: true
  defp validate_status_fsm(:open, :closed), do: true
  defp validate_status_fsm(:open, :cancelled), do: true

  defp validate_status_fsm(:closed, :open), do: true

  defp validate_status_fsm(:joining, :ready), do: true
  defp validate_status_fsm(:joining, :cancelled), do: true

  defp validate_status_fsm(:ready, :done), do: true
  defp validate_status_fsm(:ready, :cancelled), do: true

  defp validate_status_fsm(:done, _), do: false
  defp validate_status_fsm(_, _), do: false

  defp validate_slot_type(%Ecto.Changeset{valid?: true} = changeset, attrs) do
    new_slot_type = (attrs["slot_type"] || Map.get(attrs, :slot_type)) |> to_atom()
    new_status = (attrs["status"] || Map.get(attrs, :status)) |> to_atom()

    if new_slot_type do
      case new_status do
        :ready ->
          changeset
          |> cast(%{slot_type: new_slot_type}, [:slot_type])

        _ ->
          changeset
      end
    else
      changeset
    end
  end

  defp validate_slot_type(changeset, _attrs), do: changeset

  defp to_atom(value) when is_binary(value), do: String.to_atom(value)
  defp to_atom(value), do: value
end
