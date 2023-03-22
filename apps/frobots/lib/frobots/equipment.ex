defmodule Frobots.Equipment do
  alias Frobots.Repo
  alias Frobots.Assets.{Frobot, Xframe, Missile, Scanner, Cannon}
  alias Frobots.Accounts
  import Ecto.Changeset
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
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> user_email = "dummy@example.com"
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: user_email}),
      ...> {:ok, %Assets.CannonInst{} = cn} <- Assets.create_equipment( owner1, "Cannon", :Mk1),
      ...> do: cn.user.email == user_email
      true

  """
  def create_equipment(%Accounts.User{} = user, equipment_class, equipment_type) do
    module = String.to_existing_atom("Elixir.Frobots.Assets." <> equipment_class <> "Inst")
    inst_struct = module.new(%{})
    # we have to rely on the fact the type is the get_ fn! not good.
    get_fn = String.to_existing_atom("get_" <> String.downcase(equipment_class))
    class = String.to_existing_atom(String.downcase(equipment_class))
    master_struct = apply(__MODULE__, get_fn, [equipment_type])

    inst_struct
    |> module.changeset(Map.from_struct(master_struct))
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(class, master_struct)
    |> Repo.insert()
  end

  def get_equipment(equipment_class, id) do
    type = String.to_existing_atom("Elixir.Frobots.Assets." <> equipment_type <> "Inst")

    from(eqp in type, where: eqp.id == ^id)
    |> Repo.one()
  end

  def update_equipment(equipment, attrs) do
    type = String.to_existing_atom("Elixir.Frobots.Assets." <> attrs.equipment_type <> "Inst")

    type.new(attrs)
    |> type.changeset(attrs)
    |> Repo.update()
  end

  def delete_equipment(equipment)
      when equipment in [%Xframe{}, %Cannon{}, %Scanner{}, %Missile{}] do
    Repo.delete(equipment)
  end

  # fetch frobot equipment by frobot
  def list_frobot_equipment(frobot_id) do
    cannons =
      from(c in Cannon,
        where: c.frobot_id == ^frobot_id
      )

    scanners =
      from(s in Scanner,
        where: s.frobot_id == ^frobot_id
      )

    xframes =
      from(x in Xframe,
        where: x.frobot_id == ^frobot_id
      )

    missiles =
      from(m in Missile,
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
