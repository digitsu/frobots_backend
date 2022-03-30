defmodule Frobots.AssetsTest do
  use Frobots.DataCase, async: true

  alias Frobots.Assets

  describe "frobots" do
    alias Frobots.Assets.Frobot

    @invalid_attrs %{brain_code: nil, class: nil, name: nil, xp: nil}
    @valid_attrs %{
      brain_code: "some brain_code",
      class: "some class",
      name: "some name",
      xp: 42
    }

    test "list_frobots/0 returns all frobots" do
      owner = user_fixture()
      %Frobot{id: id1} = frobot_fixture(owner)
      assert [%Frobot{id: ^id1}] = Assets.list_frobots()
      %Frobot{id: id2} = frobot_fixture(owner)
      assert [%Frobot{id: ^id1}, %Frobot{id: ^id2}] = Assets.list_frobots()
    end

    test "get_frobot!/1 returns the frobot with given id" do
      owner = user_fixture()
      %Frobot{id: id} = frobot_fixture(owner)
      assert %Frobot{id: ^id} = Assets.get_frobot!(id)
    end

    test "create_frobot/1 with valid data creates a frobot" do
      owner = user_fixture()
      assert {:ok, %Frobot{} = frobot} = Assets.create_frobot(owner, @valid_attrs)
      assert frobot.brain_code == "some brain_code"
      assert frobot.class == "some class"
      assert frobot.name == "some name"
      assert frobot.xp == 42
    end

    test "create_frobot/1 with invalid data returns error changeset" do
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.create_frobot(owner, @invalid_attrs)
    end

    test "update_frobot/2 with valid data updates the frobot" do
      owner = user_fixture()
      frobot = frobot_fixture(owner)

      update_attrs = %{
        brain_code: "some updated brain_code",
        class: "some updated class",
        name: "some updated name",
        xp: 43
      }

      assert {:ok, %Frobot{} = frobot} = Assets.update_frobot(frobot, update_attrs)
      assert frobot.brain_code == "some updated brain_code"
      assert frobot.class == "some updated class"
      assert frobot.name == "some updated name"
      assert frobot.xp == 43
    end

    test "update_frobot/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %Frobot{id: id} = frobot = frobot_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Assets.update_frobot(frobot, @invalid_attrs)
      assert %Frobot{id: ^id} = Assets.get_frobot!(id)
    end

    test "delete_frobot/1 deletes the frobot" do
      owner = user_fixture()
      frobot = frobot_fixture(owner)
      assert {:ok, %Frobot{}} = Assets.delete_frobot(frobot)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_frobot!(frobot.id) end
    end

    test "change_frobot/1 returns a frobot changeset" do
      owner = user_fixture()
      frobot = frobot_fixture(owner)
      assert %Ecto.Changeset{} = Assets.change_frobot(frobot)
    end
  end
end
