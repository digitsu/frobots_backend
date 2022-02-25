defmodule FrobotsRigs do
  alias Operate.VM
  alias Fubars.Frobot
  alias Fubars.Tank
  alias Fubars.Rig
  alias Fubars.Registry

  @doc
  """
  This is on the side of the frobot lua. Its only access to the rest of the system is the VM that is created by the frobot agent
  This is not a genserver
  This module has fns that govern the callbacks that the VM calls to the Rig from the frobot brain
  """

  def rig_name( vm ) do
    VM.get!(vm, "tank_name")
  end

  def rig_pid( vm ) do
    {:ok, tank_pid} = Registry.lookup(Registry, rig_name(vm), :tank)
    tank_pid
  end

  def frobot_name( vm ) do
    VM.get!(vm, "frobot_name")
  end

  def frobot_pid( vm ) do
    Registry.lookup(Registry, frobot_name(vm), :frobot)
  end

  def create_frobot(name, brain_path) do
    #GenServer.start_link(Frobot, %Frobot{frobot_name: name, brain_path: brain_path } )
    Registry.create(Registry, name, :frobot, %Frobot{brain_path: brain_path } )
  end

  def cpu_cycle_buffer(frobot_pid) do
    Map.get(Frobot.get_state(frobot_pid), :cpu_cycle_buffer)
  end

  def cpu_burn_cycles(frobot_pid, cycles) do
    Map.put(frobot_pid, cpu_cycle_buffer(frobot_pid) - cycles)
  end

  # frobot-rig interface
  # ####################
  def scan(vm, rig_pid, degree, res) do
    Tank.scan(rig_pid, degree, res)
  end

  def cannon(vm, rig_pid, degree, range ) do
    Tank.cannon(rig_pid, degree, range)
  end

  def drive(vm, rig_pid, heading, speed) do
    Tank.drive(rig_pid, heading, speed)
  end

  def damage(vm, rig_pid) do
    Tank.damage(rig_pid)
  end

  def speed(vm, rig_pid) do
    Tank.speed(rig_pid)
  end

  def loc_x(vm, rig_pid) do
    Tank.loc_x(rig_pid)
  end

  def loc_y(vm, rig_pid) do
    Tank.loc_y(rig_pid)
  end

  def rig_info(vm, rig_pid) do
    Rig.rig_info(rig_pid)
  end

  defmodule Extension do
    use Operate.VM.Extension
    alias Operate.VM

    @moduledoc false

    def extend(vm) do
      vm
      |> VM.set_function!("scan",     fn vm,  args -> apply(FrobotsRigs, :scan,      [vm, FrobotsRigs.rig_pid(vm)] ++ args) end)
      |> VM.set_function!("cannon",   fn vm,  args -> apply(FrobotsRigs, :cannon,    [vm, FrobotsRigs.rig_pid(vm)] ++ args) end)
      |> VM.set_function!("drive",    fn vm,  args -> apply(FrobotsRigs, :drive,     [vm, FrobotsRigs.rig_pid(vm)] ++ args) end)
      |> VM.set_function!("damage",   fn vm, _args -> apply(FrobotsRigs, :damage,    [vm, FrobotsRigs.rig_pid(vm)]        ) end)
      |> VM.set_function!("speed",    fn vm, _args -> apply(FrobotsRigs, :speed,     [vm, FrobotsRigs.rig_pid(vm)]        ) end)
      |> VM.set_function!("loc_x",    fn vm, _args -> apply(FrobotsRigs, :loc_x,     [vm, FrobotsRigs.rig_pid(vm)]        ) end)
      |> VM.set_function!("loc_y",    fn vm, _args -> apply(FrobotsRigs, :loc_y,     [vm, FrobotsRigs.rig_pid(vm)]        ) end)
      |> VM.set_function!("rig_info", fn vm, _args -> apply(FrobotsRigs, :rig_info,  [vm, FrobotsRigs.rig_pid(vm)]        ) end)

    end
  end
end

