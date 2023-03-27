defmodule Frobots.Equipment do
  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.Assets.{XframeInst, MissileInst, ScannerInst, CannonInst}
  alias Frobots.Accounts

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
      iex> user_email = "dummy@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, "cannon", "Mk1"),
      ...> do: cn.user.email == user_email
      true

      # we can also pass atoms for the equipment_class
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, :cannon, "Mk1"),
      ...> do: cn.user.email == user_email
      true

      # we can also pass atoms for the equipment_type
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Equipment.create_equipment( owner1, :cannon, :Mk1),
      ...> do: cn.user.email == user_email
      true

      # but be careful as the equipment_type is CASE SENSITIVE! as it maps to an Enum of atoms
      iex> alias Frobots.Equipment
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy@example.com"
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
    Tank Mk1: a type of an xframe
    Cannon: a type of weapon
    Cannon Mk1: a type of Cannon
    Scanner: a type of Sensor
    Scanner Mk1: a type of Scanner

    USER driven APIs should only be able to create instances of the leaf level types: "Tank Mk1", "Cannon Mk1", "Scanner Mk2", etc.
  """
  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type) when is_atom(equipment_class) do
    create_equipment(user, Atom.to_string(equipment_class), equipment_type)
  end

  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type) do
    inst_module = String.to_existing_atom("Elixir.Frobots.Assets." <> String.capitalize(equipment_class) <> "Inst")
    inst_struct = inst_module.new(%{})
    # we have to rely on the fact the type is the get_ fn!
#    get_fn = String.to_atom("get_" <> String.downcase(equipment_class) <> "!")
    get_fn = String.to_atom("get_" <> String.downcase(equipment_class) )
    master_struct = apply(Frobots.Assets, get_fn, [equipment_type])

    inst_struct
    |> inst_module.changeset(Map.from_struct(master_struct))
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(String.to_existing_atom(String.downcase(equipment_class)), master_struct)
    |> Repo.insert()
  end

  def get_equipment(equipment_class, id) do
    module = String.to_existing_atom("Elixir.Frobots.Assets." <> equipment_class <> "Inst")

    from(eqp in module, where: eqp.id == ^id)
    |> Repo.one()
  end

  def update_equipment(equipment, equipment_class, attrs) do
    module = String.to_existing_atom("Elixir.Frobots.Assets." <> equipment_class <> "Inst")

    equipment
    |> module.changeset(attrs)
    |> Repo.update()
  end

  def delete_equipment(equipment)
      when equipment in [%XframeInst{}, %CannonInst{}, %ScannerInst{}, %MissileInst{}] do
    Repo.delete(equipment)
  end

  # fetch frobot equipment by frobot
  # this is how the frontend knows the ids for parts
  def list_frobot_equipment(frobot_id) do
    cannons =
      from(c in CannonInst,
        where: c.frobot_id == ^frobot_id
      )

    scanners =
      from(s in ScannerInst,
        where: s.frobot_id == ^frobot_id
      )

    xframes =
      from(x in XframeInst,
        where: x.frobot_id == ^frobot_id
      )

    missiles =
      from(m in MissileInst,
        where: m.frobot_id == ^frobot_id
      )

    Repo.all(cannons) ++ Repo.all(scanners) ++ Repo.all(xframes) ++ Repo.all(missiles)
  end

  @doc """
  which should assign the equipment (equipe it) to that frobot, which should also incorporate logic to check the number of slots in the currently equipped xframe for the frobot.
  """
  def equip_part(_equipment, _frobot) do
    # add a frobot association to the part, see how create_equipment uses Ecto.Changeset.put_assoc().
  end

  @doc """
  need to install an xframe onto a frobot. this needs to be done first, because equip_part() cannot be executed before a frobot has its xframe installed.
  """
  def equip_xframe(_xframe, _frobot) do
  end

  @doc """
  should nil out the frobot_id on the equipment if it is currently set. It should also set anything on the frobot that may rely on this part being equipped, for instance, if there is any field indicating that it is 'ready' or 'playable' in a match. Dequip(xframe) will automatically dequip all its equipment as well.
  """
  def dequip_part(_equipment) do
    # remove the frobot association from a part
  end

  @doc """
  dequip everything from the frobot
  """
  def dequip_all(_frobot) do
  end

  @doc """
  dequip everything except any xframe
  """
  def dequip_parts(_frobot) do
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
  end
end
