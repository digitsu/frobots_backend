defmodule FrobotsConsole do
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
  defdelegate run(), to: FrobotsConsole.Application

  defdelegate test_run(), to: FrobotsConsole.Application
end
