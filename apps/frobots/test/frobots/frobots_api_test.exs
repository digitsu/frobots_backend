defmodule Frobots.FrobotsApiTest do
  use Frobots.DataCase, async: true
  alias Frobots.Api
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

    multi = Api._frobot_insert_multi(user, @valid_frobot_attrs)

    assert [
             {:frobot, {:insert, frobot_cs, []}},
             {:xframe_inst, {:insert, _xframe_inst_cs, []}},
             {:cannon_inst, {:insert, _cannon_inst_cs, []}},
             {:scanner_inst, {:insert, _scanner_inst_cs, []}},
             {:missile_inst, {:insert, _missile_inst_cs, []}},
             {:cpu_inst, {:insert, _cpu_inst_cs, []}},
             {:xframe_inst_mk2, {:insert, _xframe_inst_mk2_cs, []}},
             {:cannon_inst_mk2, {:insert, _cannon_inst_mk2_cs, []}},
             {:scanner_inst_mk2, {:insert, _scanner_inst_mk2_cs, []}},
             {:missile_inst_mk2, {:insert, _missile_inst_mk2_cs, []}},
             {:xframe_inst_mk3, {:insert, _xframe_inst_mk3_cs, []}},
             {:cannon_inst_mk3, {:insert, _cannon_inst_mk3_cs, []}},
             {:scanner_inst_mk3, {:insert, _scanner_inst_mk3_cs, []}},
             {:equip_xframe, {:run, _equip_xframe_cs}},
             {:equip_cannon, {:run, _equip_cannon_cs}},
             {:equip_scanner, {:run, _equip_scanner_cs}},
             {:equip_cpu, {:run, _equip_cpu_cs}},
             # {:equip_missile, {:run, _equip_missile_cs}},
             {:update_user, {:run, _update_user_cs}}
           ] = Ecto.Multi.to_list(multi)

    assert frobot_cs.valid?
    assert {:ok, frobot_id} = Api._run_multi(multi)
    assert frobot_id > 0

    refresh_user = Accounts.get_user_by(id: user.id)
    assert refresh_user.sparks == 5
  end

  test "Calling Api.create_frobot with invalid attributes returns error" do
    {:ok, user} = user_fixture(%{sparks: 6})

    multi = Api._frobot_insert_multi(user, @invalid_frobot_attrs)

    assert [
             {:frobot, {:insert, frobot_cs, []}},
             {:xframe_inst, {:insert, _xframe_inst_cs, []}},
             {:cannon_inst, {:insert, _cannon_inst_cs, []}},
             {:scanner_inst, {:insert, _scanner_inst_cs, []}},
             {:missile_inst, {:insert, _missile_inst_cs, []}},
             {:cpu_inst, {:insert, _cpu_inst_cs, []}},
             {:xframe_inst_mk2, {:insert, _xframe_inst_mk2_cs, []}},
             {:cannon_inst_mk2, {:insert, _cannon_inst_mk2_cs, []}},
             {:scanner_inst_mk2, {:insert, _scanner_inst_mk2_cs, []}},
             {:missile_inst_mk2, {:insert, _missile_inst_mk2_cs, []}},
             {:xframe_inst_mk3, {:insert, _xframe_inst_mk3_cs, []}},
             {:cannon_inst_mk3, {:insert, _cannon_inst_mk3_cs, []}},
             {:scanner_inst_mk3, {:insert, _scanner_inst_mk3_cs, []}},
             {:equip_xframe, {:run, _equip_xframe_cs}},
             {:equip_cannon, {:run, _equip_cannon_cs}},
             {:equip_scanner, {:run, _equip_scanner_cs}},
             {:equip_cpu, {:run, _equip_cpu_cs}},
             {:update_user, {:run, _update_user_cs}}
           ] = Ecto.Multi.to_list(multi)

    refute frobot_cs.valid?
    assert {:error, _errors} = Api._run_multi(multi)
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
