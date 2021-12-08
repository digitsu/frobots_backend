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
    Arena.kill_all!(Arena)
    pid = FrobotsRigs.create_frobot(:rabbit_alpha, "apps/frobots_rigs/src/dummy.lua")
    state = Frobot.get_state(pid)
    vm = state.vm
    vm |> Operate.VM.eval!(File.read!("apps/frobots_rigs/src/dummy.lua")) |> Operate.VM.exec_function!([])

    #FrobotsConsole.Game.run([pid])
  end

  def test_run() do
    Game.init_logger()
    location = {:rand.uniform(1000), :rand.uniform(1000)}
    Arena.create(Arena, :t1, :tank, loc: location)
    FrobotsConsole.Game.run([])
  end
  #defdelegate test_run(), to: FrobotsConsole.Game
end
