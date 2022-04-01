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
              # name: nil, # I believe this isn't used...
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
    # normally should take these from the command args
    tty = "/dev/ttys000"
    frobots = %{"alpha" => "../frobots/templates/sniper.lua"}
    frobots = Map.put(frobots, "beta", "../frobots/templates/sniper.lua")
    frobots = Map.put(frobots, "gamma", "../frobots/templates/random.lua")
    frobots = Map.put(frobots, "delta", "../frobots/templates/random.lua")
    frobots = Map.put(frobots, "epsilon", "../frobots/templates/sniper.lua")
    frobots = Map.put(frobots, "mu", "../frobots/templates/rabbit.lua")
    FrobotsConsole.Game.run(%{frobots: frobots, tty: tty})
  end

  @doc """
   Test with just one frobot
  """
  def run_test() do
    Arena.set_debug(Arena, true)
    Arena.kill_all!(Arena)
    name = "rando"
    brain_path = "apps/frobots/templates/random.lua"
    pid = Fubars.Registry.create(Fubars.Registry, name, :frobot, %Frobot{brain_path: brain_path})
    Fubars.Frobot.start(pid)
  end
end
