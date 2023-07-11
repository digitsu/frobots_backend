defmodule Frobots.Joins.FrobotBattlelog do
  @moduledoc """
  The FrobotBattlelog context.
  """
  use Ecto.Schema

  @primary_key false
  schema "frobots_battlelogs" do
    belongs_to :frobot, Frobots.Assets.Frobot
    belongs_to :battlelog, Frobots.Events.Battlelog
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:frobot_id, :battlelog_id])
    |> Ecto.Changeset.validate_required([:frobot_id, :battlelog_id])
  end
end
