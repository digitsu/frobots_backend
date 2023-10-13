defmodule Frobots.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Frobots.Repo
  alias Frobots.Assets.{Frobot, Xframe, Missile, Scanner, Cannon, Cpu, Snippet}
  alias Frobots.Accounts

  @prototype_class "P"
  @target_class "T"
  @user_class_u "U"

  @spec user_classes :: [<<_::8>>, ...]
  def user_classes() do
    [@user_class_u]
  end

  @spec default_user_class :: <<_::8>>
  def default_user_class() do
    @user_class_u
  end

  @spec prototype_class :: <<_::8>>
  def prototype_class() do
    @prototype_class
  end

  @spec target_class :: <<_::8>>
  def target_class() do
    @target_class
  end

  def list_user_frobots(%Accounts.User{} = user) do
    Frobot
    |> frobots_user_query(user)
    |> Repo.all()
  end

  def user_frobots_count(%Accounts.User{} = user) do
    Frobot
    |> frobots_user_query(user)
    |> Repo.aggregate(:count)
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

      {:ok, %Elixir.Frobots.Assets.Frobot{}}

      iex> Frobots.Assets.get_frobot("notaname")
      {:error, :not_found}

  """
  def get_frobot(name) when is_bitstring(name) do
    Frobot
    |> frobots_name_query(name)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      frobot -> {:ok, frobot}
    end
  end

  def get_frobot(id), do: Repo.get(Frobot, id)

  def get_frobot!(name) when is_bitstring(name) do
    Frobot
    |> frobots_name_query(name)
    |> Repo.one!()
  end

  def get_frobot!(id), do: Repo.get!(Frobot, id)

  def get_frobot_by(frobot_ids, preload \\ []) do
    from(f in Frobot, where: f.id in ^frobot_ids, preload: ^preload)
    |> Repo.all()
  end

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
      # ...> %{type: :Chassis_Mk1,
      # ...>   weapon_hardpoints: 1,
      # ...>   max_speed_ms: 10,
      # ...>   turn_speed: 10,
      # ...>   sensor_hardpoints: 1,
      # ...>   movement_type: "bipedal",
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

  def get_xframe!(type) do
    from(t in Xframe, where: t.type == ^type)
    |> Repo.one!()
  end

  def list_xframes() do
    Repo.all(Xframe)
  end

  def update_xframe(xframe, attrs) do
    xframe_cs = Xframe.changeset(xframe, attrs)

    case Repo.update(xframe_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  # fetch frobots by user
  def get_user_frobots(user_id) do
    q =
      from(fr in Frobot,
        where: fr.user_id == ^user_id
      )

    Repo.all(q)
  end

  def get_available_user_frobots(user_id) do
    Repo.all(
      from(f in Frobot,
        where:
          f.user_id == ^user_id and
            fragment(
              "id NOT IN (select frobot_id from slots as s left join matches as m on s.match_id = m.id where (m.status = 'pending' or m.status = 'running') and s.status = 'ready')"
            )
      )
    )
  end

  @doc ~S"""
  Creates a cannon.

  ## Examples

      #iex> create_cannon(%{field: value})
      #{:ok, %Cannon{}}

      #iex> create_cannon(%{field: bad_value})
      #{:error, %Ecto.Changeset{}}
      #doctest barfs if i dont comment above code

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

  def get_cannon!(type) do
    from(c in Cannon, where: c.type == ^type)
    |> Repo.one!()
  end

  def update_cannon(cannon, attrs) do
    cannon_cs = Cannon.changeset(cannon, attrs)

    case Repo.update(cannon_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_cannons() do
    Repo.all(Cannon)
  end

  @doc ~S"""
  Creates a Missile.

  ## Examples

      #iex> create_missile(%{field: value})
      #{:ok, %Missile{}}

      #iex> create_missile(%{field: bad_value})
      #{:error, %Ecto.Changeset{}}
      #doctest barfs if i dont comment above code

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

  def get_missile!(type) do
    from(m in Missile, where: m.type == ^type)
    |> Repo.one!()
  end

  def update_missile(missile, attrs) do
    missile_cs = Missile.changeset(missile, attrs)

    case Repo.update(missile_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_missiles() do
    Repo.all(Missile)
  end

  @doc ~S"""
  Creates a Scanner.

  ## Examples

      #iex> create_scanner(%{field: value})
      #{:ok, %Scanner{}}

      #iex> create_scanner(%{field: bad_value})
      #{:error, %Ecto.Changeset{}}
      #doctest barfs if i dont comment above code

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

  def get_scanner!(type) do
    from(s in Scanner, where: s.type == ^type)
    |> Repo.one!()
  end

  def update_scanner(scanner, attrs) do
    scanner_cs = Scanner.changeset(scanner, attrs)

    case Repo.update(scanner_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_scanners() do
    Repo.all(Scanner)
  end

  @doc ~S"""
  Creates a Cpu.

  ## Examples

      #iex> create_cpu(%{field: value})
      #{:ok, %Cpu{}}

      #iex> create_cpu(%{field: bad_value})
      #{:error, %Ecto.Changeset{}}
      #doctest barfs if i dont comment above code
  """
  def create_cpu(attrs \\ %{}) do
    %Cpu{}
    |> Cpu.changeset(attrs)
    |> Repo.insert()
  end

  def create_cpu!(attrs \\ %{}) do
    %Cpu{}
    |> Cpu.changeset(attrs)
    |> Repo.insert!()
  end

  def get_cpu(type) do
    from(c in Cpu, where: c.type == ^type)
    |> Repo.one()
  end

  def get_cpu!(type) do
    from(c in Cpu, where: c.type == ^type)
    |> Repo.one!()
  end

  def update_cpu(cpu, attrs) do
    cpu_cs = Cpu.changeset(cpu, attrs)

    case Repo.update(cpu_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_cpu() do
    Repo.all(Cpu)
  end

  ## Snippet

  ## code,
  ## name,
  ## user_id

  def create_snippet(attrs \\ %{}) do
    %Snippet{}
    |> Snippet.changeset(attrs)
    |> Repo.insert()
  end

  def create_snippet!(attrs \\ %{}) do
    %Snippet{}
    |> Snippet.changeset(attrs)
    |> Repo.insert!()
  end

  def get_snippet(id) do
    from(s in Snippet, where: s.id == ^id)
    |> Repo.one()
  end

  def get_snippet!(id) do
    from(s in Snippet, where: s.id == ^id)
    |> Repo.one!()
  end

  def update_snippet(snippet, attrs) do
    snippet_cs = Snippet.changeset(snippet, attrs)

    case Repo.update(snippet_cs) do
      {:ok, _struct} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  def list_snippet(user_id) do
    from(s in Snippet, where: s.user_id == ^user_id)
    |> Repo.all()
  end

  def delete_snippet(snippet_id) do
    snippet_id
    |> get_snippet!()
    |> Repo.delete()
  end
end
