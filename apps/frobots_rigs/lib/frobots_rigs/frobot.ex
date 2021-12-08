defmodule Frobot do
  @moduledoc false
  alias Operate.VM
  alias Fubars.Arena
  alias Fubars.Rig
  require Logger

  defstruct brain_path: nil,
            frobot_name: nil,
            vm: nil,
            brain_cell: nil

  use GenServer

  def start_link(%__MODULE__{}, opts) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, opts)
  end

  def get_state(frobot) do
    GenServer.call(frobot, :get_state)
  end

  def start(frobot) do
    GenServer.cast(frobot, :start)
  end

  defp place_tank(name) do
    args = [loc: {:rand.uniform(Arena.length()), :rand.uniform(Arena.height())}]
    case Arena.create(Arena, name, :tank, args) do
      {:ok, tank} -> Rig.go(tank) # Vroom Vroom!
      {:error, :bad_loc} -> place_tank(name)
    end
  end

  @impl true
  def init(%__MODULE__{} = init_state) do
    name = Map.fetch!(init_state, :frobot_name)
    brain_path = Map.fetch!(init_state, :brain_path)

    place_tank(name)

    vm =  VM.init
          |> VM.set!("rig_name", name)
          |> VM.extend([FrobotsRigs.Extension])
    state = init_state
            |> Map.put(:vm, vm)
            |> Map.put(:brain_cell, %Operate.Cell{op: File.read!(brain_path), params: []})
    {:ok, state}
  end


  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:start, state) do
    Operate.Cell.exec(state.brain_cell, state.vm) # the frobot will block here for its run
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    Logger.debug("\nfrobot terminate/2 callback")
    Arena.kill_rig(Arena, state.frobot_name, :tank)
  end
end