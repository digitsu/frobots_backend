defmodule Frobots.Leaderboard.Stats do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :points,
             :xp,
             :attempts,
             :matches_won,
             :matches_participated,
             :frobot_id,
             :user_id
           ]}
  ## avatar, username to be preloaded
  schema "leaderboard_stats" do
    field :points, :integer, default: 0
    field :xp, :integer, default: 0
    field :attempts, :integer, default: 0
    field :matches_won, :integer, default: 0
    field :matches_participated, :integer, default: 0
    field :user_id, :integer, default: 0

    belongs_to :frobot, Frobots.Assets.Frobot

    timestamps()
  end

  @fields [:points, :xp, :attempts, :matches_won, :matches_participated, :frobot_id, :user_id]

  @doc false
  def changeset(leaderboard_stat, attrs) do
    leaderboard_stat
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:frobot], name: :unique_frobot_id)
  end
end
