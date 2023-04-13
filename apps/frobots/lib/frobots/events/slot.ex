defmodule Frobots.Events.Slot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder, only: [:status, :match_id, :frobot_id, :slot_type]}
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
    |> cast(attrs, @fields ++ [:slot_type, :frobot_id, :match_id, :match_type])
    |> cast_assoc(:match)
    |> validate_required(@fields)
    |> validate_slot_type(attrs)
    |> unique_constraint(:frobot_id,
      name: :unique_frobot_id_slot,
      message: "is already used in a match"
    )
  end

  @doc false
  def update_changeset(slot, attrs) do
    slot
    |> cast(attrs, @fields ++ [:frobot_id, :slot_type])
    |> validate_status(attrs)
    |> validate_slot_type(attrs)
    |> unique_constraint(:frobot_id,
      name: :unique_frobot_id_slot,
      message: "is already used in a match"
    )
  end

  defp validate_status(%Ecto.Changeset{valid?: true} = changeset, attrs) do
    if attrs["status"] do
      case validate_status_fsm(get_change(changeset, :status), attrs["status"]) do
        true ->
          changeset

        false ->
          add_error(
            changeset,
            :status,
            "unable to update the slot from #{get_change(changeset, :status)} to #{attrs["status"]}"
          )
      end
    else
      changeset
    end
  end

  defp validate_status(changeset, _attrs), do: changeset

  defp validate_status_fsm(:open, :joining), do: true
  defp validate_status_fsm(:open, :closed), do: true
  defp validate_status_fsm(:closed, :open), do: true
  defp validate_status_fsm(:joining, :ready), do: true
  defp validate_status_fsm(_, _), do: false

  defp validate_slot_type(%Ecto.Changeset{valid?: true} = changeset, attrs) do
    if attrs["slot_type"] do
      case get_change(changeset, :status) do
        :ready ->
          changeset

        _ ->
          add_error(
            changeset,
            :slot_type,
            "unable to update the slot type for #{get_change(changeset, :status)}"
          )
      end
    else
      changeset
    end
  end

  defp validate_slot_type(changeset, _attrs), do: changeset
end
