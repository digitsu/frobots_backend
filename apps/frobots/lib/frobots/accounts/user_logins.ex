defmodule Frobots.Accounts.UserLogin do
  @moduledoc """
  The UserLogin context.
  """
  use Ecto.Schema
  import Ecto.Query
  alias Frobots.Accounts.{User, UserLogin}

  schema "user_logins" do
    belongs_to(:user, User)

    timestamps(updated_at: false)
  end

  @doc """
  Returns login changeset.
  """
  def changeset(%UserLogin{} = login_log, attrs \\ %{}) do
    login_log
    |> Ecto.Changeset.cast(attrs, [:user_id])
    |> Ecto.Changeset.validate_required([:user_id])
  end

  @doc """
  Gets the user login history
  """
  def get_user_logins(user_id) do
    from(l in UserLogin, where: l.user_id == ^user_id)
  end
end
