defmodule Frobots.Events.Battlelog do
  # this defines what is saved when a match is completed.
  use Ecto.Schema
  import Ecto.Changeset

  # a battlelog is written after a match is completed, and there are winners declared.
  schema "battlelogs" do
    # ids of the of the winning frobots (expected to be in the frobots list)
    field :winners, {:array, :integer}
    # total pot of qudos/money
    field :qudos_pool, :integer
    # absolute amount of qudos rewarded to each frobot by index
    field :payouts, {:array, :integer}
    # odds of each frobot chances of winning (ref by index)
    field :odds, {:array, :float}
    # total qudos paid in commission
    field :commission_paid, :integer
    many_to_many :frobots, Frobots.Assets.Frobot, join_through: Frobots.Joins.FrobotBattlelog
    belongs_to :match, Frobots.Events.Match
    field :death_map, :map, default: %{}
    timestamps()
  end

  @doc false
  def changeset(battlelog, attrs) do
    battlelog
    |> cast(attrs, [:winners, :qudos_pool, :payouts, :odds, :commission_paid, :death_map])
    |> validate_required([:winners, :qudos_pool, :payouts, :odds, :commission_paid, :death_map])
    |> unique_constraint([:match])
  end
end
