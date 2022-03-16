defmodule Frobots.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Frobots.Assets` context.
  """

  @doc """
  Generate a frobot.
  """
  def frobot_fixture(attrs \\ %{}) do
    {:ok, frobot} =
      attrs
      |> Enum.into(%{
        brain_code: "some brain_code",
        class: "some class",
        name: "some name",
        xp: 42
      })
      |> Frobots.Assets.create_frobot()

    frobot
  end
end
