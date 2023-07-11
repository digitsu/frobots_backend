defmodule Frobots.Assets.CpuInst do
  @moduledoc """
  The CpuInst context.
  """
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :user_id,
             :cpu_id,
             :frobot_id,
             :cycletime,
             :cpu_cycle_buffer,
             :overload_penalty
           ]}

  schema "cpu_inst" do
    belongs_to :user, Frobots.Accounts.User
    belongs_to :frobot, Frobots.Assets.Frobot
    belongs_to :cpu, Frobots.Assets.Cpu

    field(:cycletime, :integer)
    field(:cpu_cycle_buffer, :integer)
    field(:overload_penalty, :integer)
    timestamps()
  end

  @fields [
    :cycletime,
    :cpu_cycle_buffer,
    :overload_penalty
  ]

  @doc false
  def changeset(cpu, attrs) do
    cpu
    |> cast(attrs, @fields ++ [:cpu_id, :user_id, :frobot_id])
  end
end
