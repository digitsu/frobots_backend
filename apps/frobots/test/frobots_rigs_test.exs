defmodule FrobotsTest do
  use ExUnit.Case
  alias Fubars.Frobot

  test "create a rabbit" do
    assert {:ok, pid} = GenServer.start_link(Frobot, %Frobot{name: "rabbit1", brain_path: "src/rabbit.lua" } )
    assert Process.alive?(pid)

    Frobot.prestart(pid)
    assert state = Frobot.get_state(pid)
    vm = state.vm
    damage = vm |> Operate.VM.eval!("return function() return damage() end") |> Operate.VM.exec_function!([])
    assert damage == 0
    x =  vm |> Operate.VM.eval!("return function() return loc_x() end") |> Operate.VM.exec_function!([])
    y =  vm |> Operate.VM.eval!("return function() return loc_y() end") |> Operate.VM.exec_function!([])
    assert x > 0
    assert y > 0 # yeah maybe this test may fail due to the random nature of the loc, but meh
    rig_info = vm |> Operate.VM.eval!("return function() return rig_info() end") |> Operate.VM.exec_function!([])
    assert rig_info == %{"model" => "Tank mk1", "cpu_cycle_cost" => %{"cannon" => 25, "damage" => 1, "drive" => 40, "loc_x" => 1, "loc_y" => 1, "scan" => 2, "speed" => 1}}

    cycles = vm |> Operate.VM.eval!("return function() return cycles() end") |> Operate.VM.exec_function!([])
    assert cycles == 57
    _res = vm |> Operate.VM.eval!("return function() return cannon( 90, 100 ) end") |> Operate.VM.exec_function!([])
    cycles = vm |> Operate.VM.eval!("return function() return cycles() end") |> Operate.VM.exec_function!([])
    assert cycles == 32
  end
end
