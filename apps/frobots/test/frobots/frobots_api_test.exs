defmodule Frobots.FrobotsApiTest do
  use Frobots.DataCase, async: true
  alias Frobots.Api
  alias Frobots.Assets.Frobot
  alias Ecto.Multi
  alias Frobots.Accounts

  @valid_frobot_attrs %{
    "name" => "samurai",
    "brain_code" => "return true",
    "bio" => "bio",
    "blockly_code" => "blockly"
  }

  @invalid_frobot_attrs %{"name" => "samurai", "bio" => "bio", "blockly_code" => "blockly"}

  test "Calling Api.create_frobot with valid attributes creates frobot" do
    {:ok, user} = user_fixture(%{sparks: 6})

    multi = Api.build_multi(user, @valid_frobot_attrs)

    assert [
             {:frobot, {:insert, frobot_cs, []}},
             {:xframe_inst, {:insert, xframe_inst_cs, []}},
             {:cannon_inst, {:insert, cannon_inst_cs, []}},
             {:scanner_inst, {:insert, scanner_inst_cs, []}},
             {:missile_inst, {:insert, missile_inst_cs, []}},
             {:equip_xframe, {:run, equip_xframe_cs}},
             {:equip_cannon, {:run, equip_cannon_cs}},
             {:equip_scanner, {:run, equip_scanner_cs}},
             {:update_user, {:run, update_user_cs}}
           ] = Ecto.Multi.to_list(multi)

    assert frobot_cs.valid?
    assert {:ok, frobot_id} = Api.run_multi(multi)
    assert frobot_id > 0

    refresh_user = Accounts.get_user_by(id: user.id)
    assert refresh_user.sparks == 5
  end

  test "Calling Api.create_frobot with invalid attributes returns error" do
    {:ok, user} = user_fixture(%{sparks: 6})

    multi = Api.build_multi(user, @invalid_frobot_attrs)

    assert [
             {:frobot, {:insert, frobot_cs, []}},
             {:xframe_inst, {:insert, xframe_inst_cs, []}},
             {:cannon_inst, {:insert, cannon_inst_cs, []}},
             {:scanner_inst, {:insert, scanner_inst_cs, []}},
             {:missile_inst, {:insert, missile_inst_cs, []}},
             {:equip_xframe, {:run, equip_xframe_cs}},
             {:equip_cannon, {:run, equip_cannon_cs}},
             {:equip_scanner, {:run, equip_scanner_cs}},
             {:update_user, {:run, update_user_cs}}
           ] = Ecto.Multi.to_list(multi)

    refute frobot_cs.valid?
    assert {:error, errors} = Api.run_multi(multi)
    # assert {:ok, result} = Api.run_multi(multi)
  end

  test "User with insufficient sparks cannot create frobot" do
    {:ok, user} = user_fixture(%{sparks: 0})
    name = "samurai"
    brain_code = "return true"
    optional_params = %{"bio" => "fights like a ninja", "blockly_code" => "fubar"}

    assert {:error, "User does not have enough sparks."} =
             Api.create_frobot(user, name, brain_code, optional_params)
  end

  test "Frobot cannot be created without mandatory parameters" do
    {:ok, user} = user_fixture(%{sparks: 6})
    optional_params = %{"bio" => "fights like a ninja", "blockly_code" => "fubar"}

    assert {:error, "Frobot name and braincode are required."} =
             Api.create_frobot(user, "", "", optional_params)
  end
end
