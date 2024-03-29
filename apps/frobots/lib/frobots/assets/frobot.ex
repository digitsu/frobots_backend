defmodule Frobots.Assets.Frobot do
  @moduledoc """
  The Frobot context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :brain_code, :class, :xp, :blockly_code, :avatar]}

  schema "frobots" do
    field :name, :string
    field :brain_code, :string
    field :class, :string, default: ""
    field :xp, :integer, default: 0
    field :blockly_code, :string, default: ""
    field :avatar, :string, default: ""
    field :bio, :string, default: ""
    field :pixellated_img, :string
    belongs_to :user, Frobots.Accounts.User

    many_to_many :battlelogs, Frobots.Events.Battlelog,
      join_through: Frobots.Joins.FrobotBattlelog

    has_one :xframe_inst, Frobots.Assets.XframeInst
    has_one :cpu_inst, Frobots.Assets.CpuInst
    has_many :cannon_inst, Frobots.Assets.CannonInst
    has_many :scanner_inst, Frobots.Assets.ScannerInst
    has_many :missile_inst, Frobots.Assets.MissileInst
    timestamps()
  end

  @doc false
  def changeset(frobot, attrs \\ %{}) do
    frobot
    |> cast(attrs, [
      :brain_code,
      :class,
      :name,
      :xp,
      :blockly_code,
      :avatar,
      :pixellated_img,
      :bio
    ])
    |> validate_required([:brain_code, :name])
    |> unique_constraint([:name])
  end
end
