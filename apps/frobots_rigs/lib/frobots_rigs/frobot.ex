defmodule Frobot do
  @moduledoc false
  alias Operate.VM
  alias Fubars.Arena
  alias Fubars.Rig
  require Logger

  defstruct brain_path: nil,
            frobot_name: nil,
            vm: nil,
            brain_cell: nil,
            tank_pid: nil,
            loop_timer: nil,
            brain_state: %{}

  use GenServer

  @cycletime 250

  def start_link(%__MODULE__{}, opts) do
    GenServer.start_link(__MODULE__, %__MODULE__{}, opts)
  end

  def get_state(frobot) do
    GenServer.call(frobot, :get_state)
  end

  def start(frobot, interval \\ @cycletime) do
    GenServer.cast(frobot, {:start, interval})
  end

  defp place_tank(name) do
    Logger.info( "placing tank" )
    args = [loc: {:rand.uniform(Arena.length()), :rand.uniform(Arena.height())}]
    tank = case Arena.create(Arena, name, :tank, args) do
      {:ok, tank} -> Rig.go(tank)
                     tank # Vroom Vroom!
      {:error, :bad_loc} -> place_tank(name)
      {:error, :name_exists} -> place_tank(String.to_atom(Atom.to_string(name) <> "a"))
    end
    tank
  end

  @impl true
  def init(%__MODULE__{} = state) do
    name = Map.fetch!(state, :frobot_name)
    brain_path = Map.fetch!(state, :brain_path)
    tank = place_tank(name) # only place a tank if the above succeeded
    name = Fubars.Rig.get_state(tank).name # get the name from the tank process as it may have been changed due to collision
    vm =  VM.init
          |> VM.set!("rig_name", name)
          |> VM.extend([FrobotsRigs.Extension])
    state = state
            |> Map.put(:vm, vm)
            |> Map.put(:brain_cell, %Operate.Cell{op: File.read!(brain_path), params: []})
            |> Map.put(:tank_pid, tank)
    {:ok, state}
  end


  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:start, interval}, state) do

    state = case Operate.Cell.exec(state.brain_cell, state.vm, state: state.brain_state) do
      {:ok, new_brain_state } ->
        #IO.inspect new_brain_state
        Map.put(state, :brain_state, new_brain_state)
      {:error, _} ->
        Map.put(state, :brain_state, state.brain_state)
    end

    timer_ref = Process.send_after(self(), {:loop, interval}, interval)
    state = Map.put(state, :loop_timer, timer_ref)
    {:noreply, state}
  end

  @impl true
  def handle_info({:loop, interval}, state) do
    Frobot.start(self(), interval)
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    Logger.debug("\nfrobot terminate/2 callback")
    Arena.kill_rig(Arena, state.frobot_name, :tank)
  end
end