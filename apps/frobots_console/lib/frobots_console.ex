defmodule FrobotsConsole do
  alias FrobotsConsole.Game
  alias Fubars.Arena

  @moduledoc """
  Documentation for `FrobotsConsole`.
  """
  defmodule Tank do
    defstruct scan: {0, 0},
              damage: 0,
              speed: 0,
              heading: 0,
              ploc: {0, 0},
              loc: {0, 0},
              id: nil,
              timer: nil,
              status: :alive
  end

  defmodule Missile do
    defstruct ploc: {0, 0},
              loc: {0, 0},
              timer: nil,
              status: :flying
  end

  @doc """
  Play a game
  """
  def run() do
    # load all the other needed apps, because in the test mode we set it not to load anything to avoid async testn issues
    for app <- Application.spec(:fubars, :applications) do
      Application.ensure_all_started(app)
    end
    Arena.set_debug(Arena, true)
    Arena.kill_all!(Arena)
    #normally should take these from the args
    frobots = %{alpha: "apps/frobots_rigs/src/rabbit.lua"}
    frobots = Map.put(frobots, :beta, "apps/frobots_rigs/src/rabbit.lua")
    frobots = Map.put(frobots, :gamma, "apps/frobots_rigs/src/rabbit.lua")
    frobots = Map.put(frobots, :delta, "apps/frobots_rigs/src/rabbit.lua")
    #pid = FrobotsRigs.create_frobot(:rabbit_alpha, "apps/frobots_rigs/src/rabbit.lua")
    #state = Frobot.get_state(pid)
    #vm = state.vm
    #vm |> Operate.VM.eval!(File.read!("apps/frobots_rigs/src/rabbit.lua")) |> Operate.VM.exec_function!([])
    FrobotsConsole.Game.run(frobots)
  end

  def test_run() do
    Game.init_logger()
    location = {:rand.uniform(1000), :rand.uniform(1000)}
    Arena.create(Arena, :t1, :tank, loc: location)
    FrobotsConsole.Game.run([])
  end
end
