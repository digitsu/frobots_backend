defmodule Frobots.TournamentManager do
  @moduledoc """
  The Tournament Manager which is a DynamicSupervisor.
  """

  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(tournament_id) do
    spec = {Frobots.Tournaments, tournament_id}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
