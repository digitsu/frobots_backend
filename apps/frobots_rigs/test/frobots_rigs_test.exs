defmodule FrobotsRigsTest do
  use ExUnit.Case
  doctest FrobotsRigs
  alias Fubars.Frobot

  test "create a rabbit" do
    assert {:ok, pid} = GenServer.start_link(Frobot, %Frobot{name: "rabbit1", brain_path: "src/rabbit.lua" } )
    assert Process.alive?(pid)

    GenServer.call(pid, :init_tank)
    assert state = Frobot.get_state(pid)
    vm = state.vm
    damage = vm |> Operate.VM.eval!("return function() return damage() end") |> Operate.VM.exec_function!([])
    assert damage == 0
    x =  vm |> Operate.VM.eval!("return function() return loc_x() end") |> Operate.VM.exec_function!([])
    y =  vm |> Operate.VM.eval!("return function() return loc_y() end") |> Operate.VM.exec_function!([])
    assert x > 0
    assert y > 0 # yeah maybe this test may fail due to the random nature of the loc, but meh
    mod_info = vm |> Operate.VM.eval!("return function() return mod_info() end") |> Operate.VM.exec_function!([])
    assert mod_info == %{"model" => "Tank mk1"}
  end
end
