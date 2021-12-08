defmodule FrobotsRigs do
  alias Fubars.Arena
  alias Operate.VM

  def test_frobot do
    cell = %Operate.Cell{op: File.read!("src/rabbit.lua"), params: []}
    {:ok, pid} =Arena.create(Arena, :test1, :tank)
    Fubars.Rig.go(pid)
    vm = Operate.VM.init([extensions: [FrobotsRigs.Extension]]) |> VM.set!("rig_name", :test1)
    Operate.Cell.exec(cell, vm)
  end


  defmodule Extension do
    alias Fubars.Tank
    alias Fubars.Registry
    use Operate.VM.Extension
    alias Operate.VM

    @moduledoc false


    def extend(vm) do

      rig_name = fn vm ->
        VM.get!(vm, "rig_name")
      end

      rig_pid = fn vm ->
        {:ok, tank_pid} = Registry.lookup(Registry, String.to_atom(rig_name.(vm)), :tank)
        tank_pid
      end

      vm
      |> VM.set_function!("scan",   fn vm,  args -> apply(Tank, :scan,    [rig_pid.(vm)] ++ args) end)
      |> VM.set_function!("cannon", fn vm,  args -> apply(Tank, :cannon,  [rig_pid.(vm)] ++ args) end)
      |> VM.set_function!("drive",  fn vm,  args -> apply(Tank, :drive,   [rig_pid.(vm)] ++ args) end)
      |> VM.set_function!("damage", fn vm, _args -> apply(Tank, :damage,  [rig_pid.(vm)]        ) end)
      |> VM.set_function!("speed",  fn vm, _args -> apply(Tank, :speed,   [rig_pid.(vm)]        ) end)
      |> VM.set_function!("loc_x",  fn vm, _args -> apply(Tank, :loc_x,   [rig_pid.(vm)]        ) end)
      |> VM.set_function!("loc_y",  fn vm, _args -> apply(Tank, :loc_y,   [rig_pid.(vm)]        ) end)
    end
  end
end

