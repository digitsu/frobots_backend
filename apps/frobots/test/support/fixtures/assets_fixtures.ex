defmodule Frobots.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Frobots.Assets` context.
  """
  alias Frobots.Accounts

  @doc """
  Generate a frobot.
  """
  def frobot_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        brain_code: "some brain_code",
        class: "some class",
        name: ~s/some name:#{:rand.uniform(1000)}/,
        xp: 42
      })

    {:ok, frobot} = Frobots.Assets.create_frobot(user, attrs)

    frobot
  end
end
