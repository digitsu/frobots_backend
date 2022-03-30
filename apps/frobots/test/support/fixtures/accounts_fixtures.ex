defmodule Frobots.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Frobots.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        username: "some@username.com",
        password: attrs[:password] || "supersecret"
      })
      |> Frobots.Accounts.register_user()

    # return a copy with the password nilified
    Map.put(user, :password, nil)
  end
end
