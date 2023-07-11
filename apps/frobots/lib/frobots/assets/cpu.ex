defmodule Frobots.Assets.Cpu do
  @moduledoc """
  The Cpu context.
  """
  use Ecto.Schema
  import Ecto.Changeset
  use ExConstructor

  @derive {Jason.Encoder,
           only: [
             :type,
             :cycletime,
             :cpu_cycle_buffer,
             :overload_penalty
           ]}

  schema "cpus" do
    field(:type, Ecto.Enum, values: ~w(Mk1 Mk2 Mk3)a)
    field(:cycletime, :integer)
    field(:cpu_cycle_buffer, :integer)
    field(:overload_penalty, :integer)

    has_many :cpu_inst, Frobots.Assets.CpuInst

    timestamps()
  end

  @fields [
    :type,
    :cycletime,
    :cpu_cycle_buffer,
    :overload_penalty
  ]

  @doc false
  def changeset(cpu, attrs) do
    cpu
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:type])
  end
end
