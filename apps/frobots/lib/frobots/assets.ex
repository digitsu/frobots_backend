defmodule Frobots.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.Assets.{Frobot, Xframe, Missile, Scanner, Cannon}
  alias Frobots.Accounts

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

      iex> Frobots.Assets.get_frobot("sniper")

      %Elixir.Frobots.Assets.Frobot{}

      iex> Frobots.Assets.get_frobot("notaname")
      nil

  """

  def get_frobot(name) when is_bitstring(name) do
    Frobot
    |> frobots_name_query(name)
    |> Repo.one()
  end

  def get_frobot(id), do: Repo.get(Frobot, id)

  def get_frobot!(name) when is_bitstring(name) do
    Frobot
    |> frobots_name_query(name)
    |> Repo.one!()
  end

  def get_frobot!(id), do: Repo.get!(Frobot, id)

  @doc ~S"""
  Creates a frobot.

  ## Examples
      # good example
      iex> alias Frobots.Assets.Frobot
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> frobot1 = %{name: "bumpkin", xp: 10, brain_code: "return\(\);"}
      iex> with {:ok, owner1} <- Fixtures.user_fixture(
      ...> %{email: Fixtures.unique_user_email()}),
      iex> {:ok, %Frobot{} = new_frobot} <- Assets.create_frobot(owner1, frobot1),
      ...> do: new_frobot.name == "bumpkin"
      true # success!

      # failed example (missing a required field)
      # failure will return error
      iex> alias Frobots.Assets.Frobot
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> frobot1 = %{name: "bumpkin", xp: 10}
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: Fixtures.unique_user_email()}),
      iex> {:error, %Ecto.Changeset{} = cs} <- Assets.create_frobot(owner1, frobot1),
      ...> do: cs.valid? == false
      true

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
      # first create one, then change it.
      iex> alias Frobots.Assets.Frobot
      iex> alias Frobots.Assets
      iex> alias Frobots.AccountsFixtures, as: Fixtures
      iex> frobot1 = %{name: "bumpkin", xp: 10, brain_code: "return\(\);"}
      iex> with {:ok, owner1} <- Fixtures.user_fixture(%{email: Fixtures.unique_user_email()}),
      iex> {:ok, %Frobot{} = new_frobot} <- Assets.create_frobot(owner1, frobot1),
      iex> {:ok, %Frobot{} = changed_frobot } <- Assets.update_frobot(new_frobot, %{brain_code: "new_code", name: "NotABumpkin"}),
      ...> do: changed_frobot.name == "NotABumpkin"
      true

  """
  def update_frobot(%Frobot{} = frobot, attrs) do
    frobot
    |> Frobot.changeset(attrs)
    |> Repo.update()
  end

  def delete_frobot(%Frobot{} = frobot) do
    Repo.delete(frobot)
  end

  @doc ~S"""
  Returns an `%Ecto.Changeset{}` for tracking frobot changes.

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

  @doc ~S"""
  Creates a xframe. (this is a master template)

  ## Examples
      # a contrived example, seeing as the schema has type a enum, which means you have to add it to the schema before you can call this fn on a new type. BUT at least we show all the needed fields for validation to pass...
      # iex> alias Frobots.Assets.Xframe
      # iex> with {:ok, %Xframe{} = xf } <- Frobots.Assets.create_xframe(
      # ...> %{type: :Tank_Mk1,
      # ...>   weapon_hardpoints: 1,
      # ...>   max_speed_ms: 10,
      # ...>   turn_speed: 10,
      # ...>   sensor_hardpoints: 1,
      # ...>   movement_type: "tracks",
      # ...>   max_health: 999,
      # ...>   max_throttle: 100,
      # ...>   accel_speed_mss: 4,
      # ...>   }),
      # ...> do: xf.max_health == 999
      # true
    don't actually run the doctest as it cannot work
  """
  def create_xframe(attrs \\ %{}) do
    %Xframe{}
    |> Xframe.changeset(attrs)
    |> Repo.insert()
  end

  def create_xframe!(attrs \\ %{}) do
    %Xframe{}
    |> Xframe.changeset(attrs)
    |> Repo.insert!()
  end

  def get_xframe(type) do
    from(t in Xframe, where: t.type == ^type)
    |> Repo.one()
  end

  def get_xframes() do
    Repo.all(Xframe)
  end

  # fetch frobots by user
  def get_user_frobots(user_id) do
    q =
      from(fr in Frobot,
        where: fr.user_id == ^user_id
      )

    Repo.all(q)
  end


  @doc ~S"""
  Creates a cannon.

  ## Examples

      iex> create_cannon(%{field: value})
      {:ok, %Cannon{}}

      iex> create_cannon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  def get_cannon(type) do
    from(c in Cannon, where: c.type == ^type)
    |> Repo.one()
  end

  def get_cannons() do
    Repo.all(Cannon)
  end

  @doc ~S"""
  Creates a Missile.

  ## Examples

      iex> create_missile(%{field: value})
      {:ok, %Missile{}}

      iex> create_missile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  def get_missile(type) do
    from(m in Missile, where: m.type == ^type)
    |> Repo.one()
  end

  def get_missiles() do
    Repo.all(Missile)
  end

  @doc """
  Creates a Scanner.

  ## Examples

      iex> create_scanner(%{field: value})
      {:ok, %Scanner{}}

      iex> create_scanner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  def get_scanner(type) do
    from(s in Scanner, where: s.type == ^type)
    |> Repo.one()
  end

  def get_scanners() do
    Repo.all(Scanner)
  end
end
