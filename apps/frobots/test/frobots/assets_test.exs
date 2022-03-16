defmodule Frobots.AssetsTest do
  use Frobots.DataCase

  alias Frobots.Assets

  describe "frobots" do
    alias Frobots.Assets.Frobot

    import Frobots.AssetsFixtures

    @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}

    test "list_frobots/0 returns all frobots" do
      frobot = frobot_fixture()
      assert Assets.list_frobots() == [frobot]
    end

    test "get_frobot!/1 returns the frobot with given id" do
      frobot = frobot_fixture()
      assert Assets.get_frobot!(frobot.id) == frobot
    end

    test "create_frobot/1 with valid data creates a frobot" do
      valid_attrs = %{brain_code: "some brain_code", class: "some class", name: "some name", xp: 42}

      assert {:ok, %Frobot{} = frobot} = Assets.create_frobot(valid_attrs)
      assert frobot.brain_code == "some brain_code"
      assert frobot.class == "some class"
      assert frobot.name == "some name"
      assert frobot.xp == 42
    end

    test "create_frobot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_frobot(@invalid_attrs)
    end

    test "update_frobot/2 with valid data updates the frobot" do
      frobot = frobot_fixture()
      update_attrs = %{brain_code: "some updated brain_code", class: "some updated class", name: "some updated name", xp: 43}

      assert {:ok, %Frobot{} = frobot} = Assets.update_frobot(frobot, update_attrs)
      assert frobot.brain_code == "some updated brain_code"
      assert frobot.class == "some updated class"
      assert frobot.name == "some updated name"
      assert frobot.xp == 43
    end

    test "update_frobot/2 with invalid data returns error changeset" do
      frobot = frobot_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.update_frobot(frobot, @invalid_attrs)
      assert frobot == Assets.get_frobot!(frobot.id)
    end

    test "delete_frobot/1 deletes the frobot" do
      frobot = frobot_fixture()
      assert {:ok, %Frobot{}} = Assets.delete_frobot(frobot)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_frobot!(frobot.id) end
    end

    test "change_frobot/1 returns a frobot changeset" do
      frobot = frobot_fixture()
      assert %Ecto.Changeset{} = Assets.change_frobot(frobot)
    end
  end
end
