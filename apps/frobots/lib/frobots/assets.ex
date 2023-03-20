defmodule Frobots.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.Assets.{Frobot, XFrame, Missile, Scanner, Cannon}
  alias Frobots.Accounts
  alias Frobots.Events

  defmodule UserStats do
    defstruct frobots_count: 0, total_xp: 0, matches_participated: 0, upcoming_matches: 0
  end

  @prototype_class "Proto"
  @target_class "Target"
  @user_class_u "U"

  def user_classes() do
    [@user_class_u]
  end

  @spec prototype_class :: <<_::40>>
  def prototype_class() do
    @prototype_class
  end

  def target_class() do
    @target_class
  end

  def list_user_frobots(%Accounts.User{} = user) do
    Frobot
    |> frobots_user_query(user)
    |> Repo.all()
  end

  def get_user_frobot!(%Accounts.User{} = user, id) do
    Frobot
    |> frobots_user_query(user)
    |> Repo.get!(id)
  end

  def list_template_frobots() do
    protos =
      Frobot
      |> frobots_class_query(@prototype_class)
      |> Repo.all()

    targets =
      Frobot
      |> frobots_class_query(@target_class)
      |> Repo.all()

    protos ++ targets
  end

  def frobots_user_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  def frobots_name_query(query, name) do
    from(v in query, where: v.name == ^name, select: v)
  end

  def frobots_class_query(query, class) do
    from(v in query, where: v.class == ^class)
  end

  @doc ~S"""
  Returns the list of frobots.

  ## Examples

      iex> Frobots.Assets.list_frobots()

      [%Frobots.Assets.Frobot{}, ...]

  """
  def list_frobots() do
    Repo.all(Frobot)
  end

  @doc ~S"""
  Gets a single frobot by name.

  nil if doesn't exist

  ## Examples

      iex> Frobots.Assets.get_frobot!(123)

      %Elixir.Frobots.Assets.Frobot{}

      iex> Frobots.Assets.get_frobot!(456)
      nil

  """
  def get_frobot(name) when is_bitstring(name) do
    Frobot
    |> frobots_name_query(name)
    |> Repo.one()
  end

  @spec get_frobot(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_frobot(id), do: Repo.get(Frobot, id)

  def get_frobot!(id), do: Repo.get!(Frobot, id)

  @doc ~S"""
  Creates a frobot.

  ## Examples

      iex> (%{})
      {:ok, %Frobots.Assets.Frobot{}}

      iex> Frobots.Assets.create_frobot(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_frobot(%Accounts.User{} = user, attrs \\ %{}) do
    %Frobot{}
    |> Frobot.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_frobot!(%Accounts.User{} = user, attrs \\ %{}) do
    %Frobot{}
    |> Frobot.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert!()
  end

  @doc ~S"""
  Updates a frobot.

  ## Examples

      iex> Frobots.Assets.update_frobot(%Frobots.Assets.Frobot{}, %{brain_code: "new_code"})
      {:ok, %Frobots.Assets.Frobot{}}

      iex> Frobots.Assets.update_frobot(%Frobots.Assets.Frobot{}, %{notafield: "blah"})
      {:error, %Ecto.Changeset{}}

  """
  def update_frobot(%Frobot{} = frobot, attrs) do
    frobot
    |> Frobot.changeset(attrs)
    |> Repo.update()
  end

  @doc ~S"""
  Deletes a frobot.

  ## Examples

      iex> Frobots.Assets.delete_frobot(%Frobots.Assets.Frobot{})
      {:ok, %Elixir.Frobots.Assets.Frobot{}}

      iex> Frobots.Assets.delete_frobot(%Frobots.Assets.Frobot{})
      {:error, %Ecto.Changeset{}}

  """
  def delete_frobot(%Frobot{} = frobot) do
    Repo.delete(frobot)
  end

  @doc ~S"""
  Returns an `%Ecto.Changeset{}` for tracking frobot changes.

  ## Examples

      iex> Frobots.Assets.change_frobot(%Elixir.Frobots.Assets.Frobot{})
      %Ecto.Changeset{data: %Elixir.Frobots.Assets.Frobot{}}

  """
  def change_frobot(%Frobot{} = frobot, attrs \\ %{}) do
    Frobot.changeset(frobot, attrs)
  end

  def load_one_frobot_from_db(%{"name" => name}) do
    case Frobots.Assets.get_frobot!(name) do
      %Frobots.Assets.Frobot{brain_code: brain_code, class: class} ->
        %{name: name, class: class, brain_code: brain_code}

      # todo handle load errors by not starting the match.
      nil ->
        %{name: name, error: "LOAD FAILED"}
    end
  end

  def load_one_frobot_from_db(%{name: name}) do
    load_one_frobot_from_db(%{"name" => name})
  end

  def load_frobots_from_db(frobots) do
    Enum.map(frobots, fn frobot -> load_one_frobot_from_db(frobot) end)
  end

  def get_user_stats(%Accounts.User{} = user) do
    user_frobots = list_user_frobots(user)

    total_xp =
      Enum.reduce(user_frobots, 0, fn x, acc ->
        if is_nil(x.xp) do
          acc
        else
          x.xp + acc
        end
      end)

    frobot_ids = Enum.map(user_frobots, fn x -> x.id end)
    match_participation_count = Events.get_match_participation_count(frobot_ids)

    # return map

    %UserStats{
      frobots_count: Enum.count(user_frobots),
      total_xp: total_xp,
      matches_participated: match_participation_count,
      upcoming_matches: 0
    }
  end

  @doc ~S"""
  Creates a xframe.

  ## Examples

      iex> Frobots.Assets.create_xframe(%{xframe_type: "NewTank MkX",
      ...> weapon_hardpoints: 1 })
      {:ok, %Elixir.Frobots.Assets.XFrame{}}

      iex> Frobots.Assets.create_xframe(%{field: "bad_value"})
      {:error, %Ecto.Changeset{}}

  """
  def create_xframe(attrs \\ %{}) do
    %XFrame{}
    |> XFrame.changeset(attrs)
    |> Repo.insert()
  end

  def create_xframe!(attrs \\ %{}) do
    %XFrame{}
    |> XFrame.changeset(attrs)
    |> Repo.insert!()
  end

  def get_xframe(xframe_type) do
    from(t in XFrame, where: t.xframe_type == ^xframe_type)
    |> Repo.one()
  end

  def get_xframes() do
    Repo.all(XFrame)
  end

  # fetch frobots by user
  def get_user_frobots(user_id) do
    q =
      from fr in Frobot,
        where: fr.user_id == ^user_id

    Repo.all(q)
  end

  # get starter cannons
  def create_cannon(attrs \\ %{}) do
    %Cannon{}
    |> Cannon.changeset(attrs)
    |> Repo.insert()
  end

  def create_cannon!(attrs \\ %{}) do
    %Cannon{}
    |> Cannon.changeset(attrs)
    |> Repo.insert!()
  end

  def get_cannon(cannon_type) do
    from(c in Cannon, where: c.cannon_type == ^cannon_type)
    |> Repo.one()
  end

  def get_cannons() do
    Repo.all(Cannon)
  end

  # get starter missiles
  def create_missile(attrs \\ %{}) do
    %Missile{}
    |> Missile.changeset(attrs)
    |> Repo.insert()
  end

  def create_missile!(attrs \\ %{}) do
    %Missile{}
    |> Missile.changeset(attrs)
    |> Repo.insert!()
  end

  def get_missile(missile_type) do
    from(m in Missile, where: m.missile_type == ^missile_type)
    |> Repo.one()
  end

  def get_missiles() do
    Repo.all(Missile)
  end

  # get starter scanners
  def create_scanner(attrs \\ %{}) do
    %Scanner{}
    |> Scanner.changeset(attrs)
    |> Repo.insert()
  end

  def create_scanner!(attrs \\ %{}) do
    %Scanner{}
    |> Scanner.changeset(attrs)
    |> Repo.insert!()
  end

  def get_scanner(scanner_type) do
    from(s in Scanner, where: s.scanner_type == ^scanner_type)
    |> Repo.one()
  end

  def get_scanners() do
    Repo.all(Scanners)
  end

  @doc ~S"""
  EQUIPMENT INTERFACE APIs
  create an instance of an equipment for the frobot.
  Only need the equipment_type to be set, the rest is ignored
  as it will get the data from the master template

  NOTE: creating a struct doesn't guarantee you can insert into the db
  it still may fail db changeset validations

  ## Examples

      iex> Frobots.Assets.create_equipment(%{equipment_type: "Cannon", reload_time: 5, rate_of_fire: 2, magazine_size: 2})

      {:ok, %Elixir.Frobots.Assets.Cannon{}}

      iex> Frobots.Assets.create_xframe(%{equipment_type: "bad_value"})

      {:ArgumentError, nil}

  """
  def create_equipment(attrs) do
    try do
      type = String.to_existing_atom("Elixir.Frobots.Assets." <> attrs.equipment_type <> "Inst")

      type.new(attrs)
      |> type.changeset(attrs)
      |> Repo.insert()
    rescue
      ArgumentError -> nil
    end
  end

  def get_equipment(equipment_type, id) do
    try do
      type = String.to_existing_atom("Elixir.Frobots.Assets." <> equipment_type <> "Inst")

      from(eqp in type, where: eqp.id == ^id)
      |> Repo.one()
    rescue
      ArgumentError -> nil
    end
  end

  def update_equipment(attrs) do
    try do
      type = String.to_existing_atom("Elixir.Frobots.Assets." <> attrs.equipment_type <> "Inst")

      type.new(attrs)
      |> type.changeset(attrs)
      |> Repo.update()
    rescue
      ArgumentError -> nil
    end
  end

  def delete_equipment(equipment)
      when equipment in [%XFrame{}, %Cannon{}, %Scanner{}, %Missile{}] do
    Repo.delete(equipment)
  end

  # fetch frobot equipment by frobot
  def list_frobot_equipment(frobot_id) do
    cannons =
      from c in Cannon,
        where: c.frobot_id == ^frobot_id

    scanners =
      from s in Scanner,
        where: s.frobot_id == ^frobot_id

    xframes =
      from x in XFrame,
        where: x.frobot_id == ^frobot_id

    missiles =
      from m in Missile,
        where: m.frobot_id == ^frobot_id

    Repo.all(cannons) ++ Repo.all(scanners) ++ Repo.all(xframes) ++ Repo.all(missiles)
  end
end
