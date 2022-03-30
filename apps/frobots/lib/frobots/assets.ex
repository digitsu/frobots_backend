defmodule Frobots.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Frobots.Repo

  alias Frobots.Assets.Frobot
  alias Frobots.Accounts

  def list_user_frobots(%Accounts.User{} = user) do
    Frobot
    |> user_frobots_query(user)
    |> Repo.all()
  end

  def get_user_frobot!(%Accounts.User{} = user, id) do
    Frobot
    |> user_frobots_query(user)
    |> Repo.get!(id)
  end

  defp user_frobots_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  @doc """
  Returns the list of frobots.

  ## Examples

      iex> list_frobots()
      [%Frobot{}, ...]

  """
  def list_frobots do
    Repo.all(Frobot)
  end

  @doc """
  Gets a single frobot.

  Raises `Ecto.NoResultsError` if the Frobot does not exist.

  ## Examples

      iex> get_frobot!(123)
      %Frobot{}

      iex> get_frobot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_frobot!(id), do: Repo.get!(Frobot, id)

  @doc """
  Creates a frobot.

  ## Examples

      iex> create_frobot(%{field: value})
      {:ok, %Frobot{}}

      iex> create_frobot(%{field: bad_value})
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

  @doc """
  Updates a frobot.

  ## Examples

      iex> update_frobot(frobot, %{field: new_value})
      {:ok, %Frobot{}}

      iex> update_frobot(frobot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_frobot(%Frobot{} = frobot, attrs) do
    frobot
    |> Frobot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a frobot.

  ## Examples

      iex> delete_frobot(frobot)
      {:ok, %Frobot{}}

      iex> delete_frobot(frobot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_frobot(%Frobot{} = frobot) do
    Repo.delete(frobot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking frobot changes.

  ## Examples

      iex> change_frobot(frobot)
      %Ecto.Changeset{data: %Frobot{}}

  """
  def change_frobot(%Frobot{} = frobot, attrs \\ %{}) do
    Frobot.changeset(frobot, attrs)
  end
end
