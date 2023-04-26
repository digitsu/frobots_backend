defmodule Frobots.Equipment do
  import Ecto.Query, warn: false
  alias Frobots.Repo

  alias Frobots.Assets.{
    XframeInst,
    MissileInst,
    ScannerInst,
    CannonInst,
    Xframe,
    Cannon,
    Scanner,
    Missile
  }

  alias Frobots.Accounts
  alias Frobots.Assets
  alias Frobots.Assets.Frobot
  alias Frobots.Api
  alias Ecto.Multi

  @equipment_structs [%XframeInst{}, %CannonInst{}, %ScannerInst{}, %MissileInst{}]
  def equipment_structs() do
    @equipment_structs
  end

  # Returns the (CRUD) getter function for this equipment
  defp _get_fn(equipment_class) do
    String.to_atom("get_" <> String.downcase(equipment_class) <> "!")
  end

  # return the master template for this equipment class and type
  defp _get_template(equipment_class, equipment_type) do
    apply(Frobots.Assets, _get_fn(equipment_class), [equipment_type])
  end

  defp _get_inst_module(equipment_class) do
    String.to_existing_atom(
      "Elixir.Frobots.Assets." <> String.capitalize(equipment_class) <> "Inst"
    )
  end

  defp _get_inst_schema(equipment_class) do
    String.to_existing_atom(String.downcase(equipment_class) <> "_inst")
  end

  defp _is_ordinance_class?(equipment_class) do
    String.downcase(equipment_class) in Enum.map(
      Frobots.ordnance_classes(),
      &Atom.to_string(&1)
    )
  end

  # functions to get master template data
  def list_xframes(), do: Repo.all(Xframe)

  def list_cannons(), do: Repo.all(Cannon)

  def list_scanners(), do: Repo.all(Scanner)

  def list_missiles(), do: Repo.all(Missile)

  @doc ~S"""
  EQUIPMENT INTERFACE APIs
  create an instance of an equipment for the frobot.
  Only need the equipment_type to be set, the rest is ignored
  as it will get the data from the master template

  Use this API from the FE as to create a INSTANCE from a template, and associate it with the frobot.

  NOTE: creating a struct doesn't guarantee you can insert into the db
  it still may fail db changeset validations

  ## Examples

      # simple case to create a equipment (and assign to a user)
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy1@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, "cannon", "Mk1"),
      ...> do: cn.user.email == user_email
      true

      # we can also pass atoms for the equipment_class
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy2@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, :cannon, "Mk1"),
      ...> do: cn.user.email == user_email
      true

      # we can also pass atoms for the equipment_type
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy3@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, :cannon, :Mk1),
      ...> do: cn.user.email == user_email
      true

      # but be careful as the equipment_type is CASE SENSITIVE! as it maps to an Enum of atoms
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy4@example.com"
      iex> try do
      ...>   with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...>        {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, :cannon, "mk1"),
      ...>        do: cn.user.email == user_email
      ...> rescue
      ...>   Ecto.Query.CastError -> "equipment_type not found"
      ...> end
      "equipment_type not found"

  ## TERMINOLOGY
  Some terms:

    Equipment: all things which are NFTs, currently, [parts, xframes]
    Part: all things which can be installed into an xframe
    Xframe: a class of equipment, each frobot can install one of these into it, which defines what parts it can install
    Weapon: class of parts which do damage, xframes define how many weapon slots it can support
    Sensor: class of parts which sense things, xframes define how many sensory slots it can support
    Chassis Mk1: a type of an xframe
    Cannon: a type of weapon
    Cannon Mk1: a type of Cannon
    Scanner: a type of Sensor
    Scanner Mk1: a type of Scanner

    USER driven APIs should only be able to create instances of the leaf level types: "Chassis Mk1", "Cannon Mk1", "Scanner Mk2", etc.
  """
  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type)
      when is_atom(equipment_class) do
    create_equipment(user, Atom.to_string(equipment_class), equipment_type)
  end

  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type)
      when is_atom(equipment_type) do
    create_equipment(user, equipment_class, Atom.to_string(equipment_type))
  end

  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type) do
    create_equipment_changeset(%Accounts.User{} = user, equipment_class, equipment_type)
    |> Repo.insert()
  end

  def get_equipment(equipment_class, id) do
    module = _get_inst_module(equipment_class)

    from(eqp in module, where: eqp.id == ^id)
    |> Repo.one()
  end

  def update_equipment(equipment, equipment_class, attrs) do
    module = _get_inst_module(equipment_class)

    equipment
    |> module.changeset(attrs)
    |> Repo.update()
  end

  def delete_equipment(equipment)
      when equipment in @equipment_structs do
    Repo.delete(equipment)
  end

  # fetch frobot equipment by frobot
  # this is how the frontend knows the ids for parts
  def list_frobot_equipment(frobot_id) do
    equipment_classes = Frobots.equipment_classes()

    equipment_classes
    |> Enum.map(fn equipment_class ->
      module = _get_inst_module(to_string(equipment_class))

      from(eqp in module, where: eqp.frobot_id == ^frobot_id)
      |> Repo.all()
    end)
  end

  # Fetch all the equipments owned by User
  def list_user_equipment(user_id) do
    equipment_classes = Frobots.equipment_classes()

    equipment_classes
    |> Enum.map(fn equipment_class ->
      module = _get_inst_module(to_string(equipment_class))

      from(eqp in module, where: eqp.user_id == ^user_id)
      |> Repo.all()
    end)
  end

  # Fetch all the equipment with details
  def list_user_equipment_details(user_id) do
    cannon_q =
      from(c in CannonInst,
        join: detail in Cannon,
        as: :cannon,
        on: c.cannon_id == detail.id,
        where: c.user_id == ^user_id
      )

    missile_q =
      from(c in MissileInst,
        join: detail in Missile,
        as: :missile,
        on: c.missile_id == detail.id,
        where: c.user_id == ^user_id
      )

    scanner_q =
      from(c in ScannerInst,
        join: detail in Scanner,
        as: :scanner,
        on: c.scanner_id == detail.id,
        where: c.user_id == ^user_id
      )

    xframe_q =
      from(c in XframeInst,
        join: detail in Xframe,
        as: :xframe,
        on: c.xframe_id == detail.id,
        where: c.user_id == ^user_id
      )

    cannons = Repo.all(cannon_q) |> Repo.preload(:cannon)
    xframes = Repo.all(xframe_q) |> Repo.preload(:xframe)
    scanners = Repo.all(scanner_q) |> Repo.preload(:scanner)
    missiles = Repo.all(missile_q) |> Repo.preload(:missile)

    %{
      "xframes" => xframes,
      "missiles" => missiles,
      "scanners" => scanners,
      "cannons" => cannons
    }
  end

  @doc """
  get all types of equipments that are not attached to a particular frobot
  """
  def list_frobot_unattached_equipments(frobot_id) do
    attached_cannon_ids =
      from(c in CannonInst,
        where: c.frobot_id == ^frobot_id,
        order_by: [asc: c.cannon_id],
        distinct: c.cannon_id,
        select: c.cannon_id
      )
      |> Repo.all()

    attached_missile_ids =
      from(m in MissileInst,
        where: m.frobot_id == ^frobot_id,
        order_by: [asc: m.missile_id],
        distinct: m.missile_id,
        select: m.missile_id
      )
      |> Repo.all()

    attached_scanner_ids =
      from(s in ScannerInst,
        where: s.frobot_id == ^frobot_id,
        order_by: [asc: s.scanner_id],
        distinct: s.scanner_id,
        select: s.scanner_id
      )
      |> Repo.all()

    attached_xframe_ids =
      from(x in XframeInst,
        where: x.frobot_id == ^frobot_id,
        order_by: [asc: x.xframe_id],
        distinct: x.xframe_id,
        select: x.xframe_id
      )
      |> Repo.all()

    cannons =
      from(cannon in Cannon,
        where: cannon.id not in ^attached_cannon_ids
      )
      |> Repo.all()

    missiles =
      from(
        missile in Missile,
        where: missile.id not in ^attached_missile_ids
      )
      |> Repo.all()

    scanners =
      from(
        scanner in Scanner,
        where: scanner.id not in ^attached_scanner_ids
      )
      |> Repo.all()

    xframes =
      from(
        xframe in Xframe,
        where: xframe.id not in ^attached_xframe_ids
      )
      |> Repo.all()

    %{
      "xframes" => _get_xframe_details(xframes),
      "missiles" => _get_missile_details(missiles),
      "scanners" => _get_scanner_details(scanners),
      "cannons" => _get_cannon_details(cannons)
    }
  end

  @doc """
  which should assign the equipment (equipe it) to that frobot, which should also incorporate logic to check the number of slots in the currently equipped xframe for the frobot.
  """
  def equip_part(equipment_instance_id, frobot_id, equipment_class) do
    call_equip_part_update(
      equip_part_changeset(equipment_instance_id, frobot_id, equipment_class)
    )
  end

  def call_equip_part_update(changeset) when changeset.valid? do
    changeset
    |> Repo.update()
    |> send_db_response()
  end

  def call_equip_part_update(changeset) when is_nil(changeset) do
    {:error, "unable to equip part, there are no open slots"}
  end

  defp send_db_response(response) do
    case response do
      {:ok, _equip_inst} ->
        {:ok, "frobot equipped with part instance"}

      {:error, %Ecto.Changeset{}} ->
        {:error, "There was an error"}
    end
  end

  @doc """
  need to install an xframe onto a frobot. this needs to be done first, because equip_part() cannot be executed before a frobot has its xframe installed.
  """

  def equip_xframe(xframe_inst_id, frobot_id) do
    result =
      equip_xframe_changeset(xframe_inst_id, frobot_id)
      |> Repo.update()

    case result do
      {:ok, _xframe_inst} ->
        {:ok, "frobot equipped with xframe instance"}

      {:error, %Ecto.Changeset{}} ->
        {:error, "There was an error in equip_xframe"}
    end
  end

  @doc """
  should nil out the frobot_id on the equipment if it is currently set. It should also set anything on the frobot that may rely on this part being equipped, for instance, if there is any field indicating that it is 'ready' or 'playable' in a match. Dequip(xframe) will automatically dequip all its equipment as well.
  """

  def dequip_part(equipment_id, class) do
    # remove the frobot association from a part
    equipment = get_equipment(class, equipment_id)
    update_equipment(class, equipment, frobot_id: nil)
  end

  @doc """
  dequip everything from the frobot
  """
  # todo - create test for dequiping!
  def dequip_all(%Assets.Frobot{} = frobot) do
    multi = Multi.new()

    changesets =
      for equipment <- list_frobot_equipment(frobot.id) do
        inst_module = _get_inst_module(equipment.class)

        cs =
          equipment
          |> Map.replace(:frobot, nil)
          |> inst_module.changeset()

        {_get_inst_schema(equipment.class), cs}
      end

    add_to_multi = fn {schema, cs}, multi ->
      Multi.insert(multi, schema, cs)
    end

    multi = Enum.reduce(changesets, multi, add_to_multi)
    Api._run_multi(multi)
  end

  @doc """
  dequip everything except any xframe
  """
  def dequip_parts(%Frobot{id: frobot_id}) do
    cannons =
      from(c in CannonInst,
        where: c.frobot_id == ^frobot_id
      )

    cannons
    |> Repo.update_all(set: [frobot_id: nil])

    scanners =
      from(s in ScannerInst,
        where: s.frobot_id == ^frobot_id
      )

    scanners
    |> Repo.update_all(set: [frobot_id: nil])

    missiles =
      from(m in MissileInst,
        where: m.frobot_id == ^frobot_id
      )

    missiles
    |> Repo.update_all(set: [frobot_id: nil])
  end

  @doc """
  dequip an xframe
  """
  def dequip_xframe(frobot) do
    # when you dequip an xframe, it Must dequip everything
    dequip_all(frobot)
  end

  @doc """
  should change the user_id of the part to someone else.... but before doing so via update_equipment() the part needs to be removed from any frobot it is currency equipped to. Call the previous dequip() API fn to do so first.
  """
  def xfer_equipment(_equipment, _touser) do
  end

  @doc """
  future function to trade a frobot, should also dequip_all() all its equipment first.
  """
  def xfer_frobot(_frobot, _fromuser, _touser) do
    # how should we expect the caller to refer to the user?
    # dequip(all) before any transfer
  end

  #############################################################################
  ## loadout API
  ##
  ## API needed for a frobot to create its 'tank' for FUBARs.
  #############################################################################

  @doc """
  getting the stats of weapons, this is used by the frobot when it is creating its 'tank'
  """
  def get_weapon_loadout(_frobot) do
    # return a list of the weapons equipped, in the form
    # find all weapons which is equipped to this frobot from the db
    # iterate through all the weapon classes... Frobots.weapon_classes()
    # with the class of the weapon, get the weapon instance from the db using the _get_fn(equipment_class)
    # the output should be as below pass back with class so that frobot can display this in FUBARs status display
    # [ %{class: :cannon, type: "Mk1", reload_time: 5, rate_of_fire: 1, magazine_size: 2} ]
  end

  @doc """
  getting the stats of the sensors
  """
  def get_sensor_loadout(_frobot) do
    # [ %{type: "Mk1", max_range: 700, resolution: 10} ]
  end

  @doc """
  get the stats of the ammunition equipped
  """
  def get_ammo_loadout(_frobot) do
    # [%{type: "Mk1",
    # damage_direct: [5,10],
    # damage_near: [20,5],
    # damage_far: [40,3],
    # speed: 400,
    # range: 900}]
  end

  def get_current_xframe(%Frobot{id: frobot_id}) do
    # return the installed xframe_inst, nil if none installed.
    # this is needed for frobot startup as it needs to get the info from its specific xframe (such as current health)
    xframes =
      from(x in XframeInst,
        where: x.frobot_id == ^frobot_id
      )

    xframes
    |> Repo.one()
  end

  # functions returning changesets..we need these as Ecto.multi requires changesets
  # create equipment changeset - called by create_equipment
  def create_equipment_changeset(%Accounts.User{} = user, equipment_class, equipment_type) do
    inst_module = _get_inst_module(equipment_class)

    inst_struct = inst_module.new(%{})
    master_struct = _get_template(equipment_class, equipment_type)

    inst_struct
    |> inst_module.changeset(Map.from_struct(master_struct))
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(
      String.to_existing_atom(String.downcase(equipment_class)),
      master_struct
    )
  end

  # get xframe changeset -- called by equip_xframe
  def equip_xframe_changeset(xframe_inst_id, frobot_id) do
    inst_module = _get_inst_module("Xframe")

    # get xframeInst
    current_frobot = Assets.get_frobot(frobot_id)
    xframe = get_equipment("Xframe", xframe_inst_id) |> Repo.preload(:frobot)

    inst_module.changeset(xframe, %{})
    |> Ecto.Changeset.put_assoc(:frobot, current_frobot)
  end

  # equip part changeset - called by equip_part
  def equip_part_changeset(equipment_instance_id, frobot_id, equipment_class) do
    inst_module = _get_inst_module(equipment_class)

    xframe = from(xfi in XframeInst, where: xfi.frobot_id == ^frobot_id) |> Repo.one()
    frobot = Assets.get_frobot(frobot_id)

    xframe_class =
      from(xf in Frobots.Assets.Xframe, where: xf.id == ^xframe.xframe_id) |> Repo.one()

    if !is_nil(xframe_class) do
      # now check how many scanner and weapon endpoints are on xframe
      max_sensor_hardpoints = xframe_class.sensor_hardpoints
      max_weapon_endpoints = xframe_class.weapon_hardpoints
      {weapon_count, sensor_count, _ammo_count} = get_equipment_count(frobot.id)

      equipment = get_equipment(equipment_class, equipment_instance_id) |> Repo.preload(:frobot)

      if _is_ordinance_class?(equipment_class) do
        build_part_changeset(
          weapon_count,
          max_weapon_endpoints,
          frobot,
          equipment,
          inst_module
        )
      else
        build_part_changeset(
          sensor_count,
          max_sensor_hardpoints,
          frobot,
          equipment,
          inst_module
        )
      end
    else
      {:error, "Xframe needs to be installed first"}
    end
  end

  defp build_part_changeset(
         total_parts,
         total_hardpoints,
         frobot,
         equipment,
         inst_module
       ) do
    if total_parts == total_hardpoints do
      nil
    else
      inst_module.changeset(equipment, %{})
      |> Ecto.Changeset.put_assoc(:frobot, frobot)
    end
  end

  defp get_equipment_count(frobot_id) do
    weapon_count =
      from(c in CannonInst, where: c.frobot_id == ^frobot_id) |> Repo.all() |> Enum.count()

    sensor_count =
      from(s in ScannerInst, where: s.frobot_id == ^frobot_id) |> Repo.all() |> Enum.count()

    ammo_count =
      from(m in MissileInst, where: m.frobot_id == ^frobot_id) |> Repo.all() |> Enum.count()

    {weapon_count, sensor_count, ammo_count}
  end

  defp _get_cannon_details(cannon_list) do
    if Enum.empty?(cannon_list) do
      []
    else
      Enum.map(cannon_list, fn cannon ->
        %{
          "id" => Map.get(cannon, :id),
          "reload_time" => Map.get(cannon, :reload_time),
          "rate_of_fire" => Map.get(cannon, :rate_of_fire),
          "magazine_size" => Map.get(cannon, :magazine_size),
          "image" => Map.get(cannon, :image),
          "equipment_class" => Map.get(cannon, :class),
          "equipment_type" => Map.get(cannon, :type)
        }
      end)
    end
  end

  defp _get_scanner_details(scanner_list) do
    if Enum.empty?(scanner_list) do
      []
    else
      Enum.map(scanner_list, fn scanner ->
        %{
          "id" => Map.get(scanner, :id),
          "max_range" => Map.get(scanner, :max_range),
          "resolution" => Map.get(scanner, :resolution),
          "image" => Map.get(scanner, :image),
          "equipment_class" => Map.get(scanner, :class),
          "equipment_type" => Map.get(scanner, :type)
        }
      end)
    end
  end

  defp _get_missile_details(missile_list) do
    if Enum.empty?(missile_list) do
      []
    else
      Enum.map(missile_list, fn missile ->
        %{
          "id" => Map.get(missile, :id),
          "damage_direct" => Map.get(missile, :damage_direct),
          "damage_near" => Map.get(missile, :damage_near),
          "damage_far" => Map.get(missile, :damage_far),
          "speed" => Map.get(missile, :speed),
          "range" => Map.get(missile, :range),
          "image" => Map.get(missile, :image),
          "equipment_class" => Map.get(missile, :class),
          "equipment_type" => Map.get(missile, :type)
        }
      end)
    end
  end

  defp _get_xframe_details(xframe_list) do
    if Enum.empty?(xframe_list) do
      []
    else
      Enum.map(xframe_list, fn xframe ->
        %{
          "id" => Map.get(xframe, :id),
          "max_speed_ms" => Map.get(xframe, :max_speed_ms),
          "turn_speed" => Map.get(xframe, :turn_speed),
          "max_health" => Map.get(xframe, :max_health),
          "health" => Map.get(xframe, :health),
          "max_throttle" => Map.get(xframe, :max_throttle),
          "accel_speed_mss" => Map.get(xframe, :accel_speed_mss),
          "image" => Map.get(xframe, :image),
          "equipment_class" => Map.get(xframe, :class),
          "equipment_type" => Map.get(xframe, :type)
        }
      end)
    end
  end
end
