defmodule FrobotsConsoleTest do
  use ExUnit.Case
  doctest FrobotsConsole

  test "Run a game" do
    assert FrobotsConsole.test_run()
  end
end
