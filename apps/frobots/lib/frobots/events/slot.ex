defmodule Frobots.Events.Slot do
  use Ecto.Schema
  import Ecto.Changeset

  alias Frobots.Events.Match
  alias Frobots.Assets.Frobot

  @derive {Jason.Encoder, only: [:status, :match_id, :frobot_id, :slot_type]}

  schema "slots" do
    field(:slot_type, Ecto.Enum, values: [:host, :protobot])
    field(:status, Ecto.Enum, values: [:open, :closed, :joining, :ready])

    belongs_to(:frobot, Frobot)
    belongs_to(:match, Match)
    timestamps()
  end

  @fields [:status]

  @doc false
  def changeset(slot, attrs) do
    slot
    |> cast(attrs, @fields ++ [:slot_type, :frobot_id, :match_id])
    |> cast_assoc(:match)
    |> validate_required(@fields)
    |> unique_constraint(:frobot_id, name: :unique_frobot_id_slot)
  end

  @doc false
  def update_changeset(slot, attrs) do
    slot
    |> cast(attrs, @fields ++ [:frobot_id, :slot_type])
    |> validate_status(attrs)
    |> unique_constraint(:frobot_id, name: :unique_frobot_id_slot)
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
end
