defmodule FrobotsConsole do
  alias Fubars.Arena
  alias Fubars.Frobot

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
    Arena.set_debug(Arena, false)
    Arena.kill_all!(Arena)
    #normally should take these from the args
    frobots = %{"alpha" => "apps/frobots_rigs/src/sniper.lua"}
    frobots = Map.put(frobots, "beta", "apps/frobots_rigs/src/sniper.lua")
    frobots = Map.put(frobots, "gamma", "apps/frobots_rigs/src/random.lua")
    frobots = Map.put(frobots, "delta", "apps/frobots_rigs/src/random.lua")
    frobots = Map.put(frobots, "epsilon", "apps/frobots_rigs/src/sniper.lua")
    frobots = Map.put(frobots, "mu", "apps/frobots_rigs/src/rabbit.lua")
    FrobotsConsole.Game.run(frobots)
  end

  @doc """
   Test with just one frobot
  """
  def run_test() do
    Arena.set_debug(Arena, true)
    Arena.kill_all!(Arena)
    name = "rando"
    brain_path = "apps/frobots_rigs/src/random.lua"
    pid = Fubars.Registry.create(Fubars.Registry, name, :frobot, %Frobot{brain_path: brain_path } )
    Fubars.Frobot.start(pid)
  end

end
