defmodule Frobots.AssetsTest do
  use Frobots.DataCase, async: true
  doctest Frobots.Assets
  doctest Frobots.Equipment

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

    @scanner %{
      type: "Mk1",
      max_range: 700,
      resolution: 10,
      class: :scanner,
      special: :active,
      image_path: "https://via.placeholder.com/50.png"
    }

    @missile %{
      type: "Mk1",
      damage_direct: [5, 10],
      damage_near: [20, 5],
      damage_far: [40, 3],
      speed: 400,
      range: 900,
      class: :missile,
      image_path: "https://via.placeholder.com/50.png"
    }

    @cannon %{
      type: "Mk1",
      reload_time: 5,
      rate_of_fire: 1,
      magazine_size: 2,
      class: :cannon,
      image_path: "https://via.placeholder.com/50.png"
    }

    @xframe %{
      type: "Chassis_Mk1",
      max_speed_ms: 30,
      turn_speed: 50,
      sensor_hardpoints: 1,
      weapon_hardpoints: 1,
      cpu_hardpoints: 1,
      movement_type: :bipedal,
      max_health: 100,
      max_throttle: 100,
      accel_speed_mss: 5,
      class: :xframe,
      image_path: "https://via.placeholder.com/50.png"
    }

    test "list_frobots/0 returns all frobots" do
      {:ok, owner} = user_fixture()
      %Frobot{id: id1} = frobot_fixture(owner)
      assert [%Frobot{id: ^id1}] = Assets.list_frobots()
      %Frobot{id: id2} = frobot_fixture(owner)
      assert [%Frobot{id: ^id1}, %Frobot{id: ^id2}] = Assets.list_frobots()
    end

    test "get_frobot!/1 returns the frobot with given id" do
      {:ok, owner} = user_fixture()
      %Frobot{id: id} = frobot_fixture(owner)
      assert %Frobot{id: ^id} = Assets.get_frobot!(id)
    end

    test "create_frobot/1 with valid data creates a frobot" do
      {:ok, owner} = user_fixture()
      assert {:ok, %Frobot{} = frobot} = Assets.create_frobot(owner, @valid_attrs)
      assert frobot.brain_code == "some brain_code"
      assert frobot.class == "some class"
      assert frobot.name == "some name"
      assert frobot.xp == 42
    end

    test "create_frobot/1 with invalid data returns error changeset" do
      {:ok, owner} = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.create_frobot(owner, @invalid_attrs)
    end

    test "update_frobot/2 with valid data updates the frobot" do
      {:ok, owner} = user_fixture()
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
      {:ok, owner} = user_fixture()
      %Frobot{id: id} = frobot = frobot_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Assets.update_frobot(frobot, @invalid_attrs)
      assert %Frobot{id: ^id} = Assets.get_frobot!(id)
    end

    test "delete_frobot/1 deletes the frobot" do
      {:ok, owner} = user_fixture()
      frobot = frobot_fixture(owner)
      assert {:ok, %Frobot{}} = Assets.delete_frobot(frobot)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_frobot!(frobot.id) end
    end

    test "change_frobot/1 returns a frobot changeset" do
      {:ok, owner} = user_fixture()
      frobot = frobot_fixture(owner)
      assert %Ecto.Changeset{} = Assets.change_frobot(frobot)
    end

    test "get_frobot!/1 with a frobot name" do
      {:ok, owner} = user_fixture()
      %Frobot{name: name} = frobot_fixture(owner)
      assert {:ok, %Frobot{name: ^name}} = Assets.get_frobot(name)
    end

    test "list_missiles fetches missiles rig data" do
      {:ok, _missile} = Assets.create_missile(@missile)
      missiles = Assets.list_missiles()
      assert Enum.count(missiles) > 0

      item = Enum.at(missiles, 0)
      assert item.type == :Mk1
    end

    test "list_cannons fetches cannons rig data" do
      {:ok, _cannon} = Assets.create_cannon(@cannon)
      cannons = Assets.list_cannons()
      assert Enum.count(cannons) > 0

      item = Enum.at(cannons, 0)
      assert item.type == :Mk1
    end

    test "list_scanners fetches scanners rig data" do
      {:ok, _scanner} = Assets.create_scanner(@scanner)
      scanners = Assets.list_scanners()
      assert Enum.count(scanners) > 0

      item = Enum.at(scanners, 0)
      assert item.type == :Mk1
    end

    test "list_xframes fetches xframes rig data" do
      {:ok, _xframe} = Assets.create_xframe(@xframe)
      xframes = Assets.list_xframes()
      assert Enum.count(xframes) > 0

      item = Enum.at(xframes, 0)
      assert item.type == :Chassis_Mk1
      assert item.movement_type == :bipedal
    end
  end
end
