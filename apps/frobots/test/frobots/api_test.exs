defmodule Frobots.ApiTest do
  use Frobots.DataCase, async: false
  alias Frobots.Api
  alias Frobots.Assets.Frobot

  setup do
    {:ok, owner} = user_fixture()
    %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
    %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})

    params = create_match_params(owner, n1, n2)
    {:ok, created_match} = Api.create_match(params)

    [created_match: created_match]
  end

  test "list matches by pagination" do
    assert %{entries: matches, page_number: 1} =
             Api.list_paginated_matches(match_status: :pending)

    assert Enum.all?(matches, fn match -> match.status == :pending end)
  end

  test "list matches by pagination with searching" do
    assert %{entries: matches, page_number: 1} =
             Api.list_paginated_matches(status: :pending, search_pattern: "my")

    assert length(matches) > 0
    assert Enum.all?(matches, fn match -> match.status == :pending end)

    ## Match not found with this pattern
    assert %{entries: matches, page_number: 1} =
             Api.list_paginated_matches(status: :pending, search_pattern: "bb")

    assert Enum.empty?(matches)
  end

  test "get match details", context do
    created_match = context.created_match
    match = Api.get_match_details_by_id(created_match.id)
    assert match.id == created_match.id
    assert match.status == :pending
    assert length(match.slots) == 4
    assert hd(match.slots).frobot
  end

  test "update slot in a match", context do
    created_match = context.created_match
    match = Api.get_match_details_by_id(created_match.id)
    assert match.id == created_match.id
    assert match.status == :pending
    assert length(match.slots) == 4

    open_slot =
      Enum.find(match.slots, fn slot ->
        slot.status == :open
      end)

    Api.update_slot(created_match, 1, open_slot.id, %{status: :closed, slot_type: nil})

    match = Api.get_match_details_by_id(created_match.id)
    assert match.id == created_match.id
    assert match.status == :pending
    assert length(match.slots) == 4

    updated_slot =
      Enum.find(match.slots, fn slot ->
        slot.id == open_slot.id
      end)

    assert is_nil(updated_slot.slot_type)
    assert updated_slot.status == :closed
  end

  defp create_match_params(owner, n1, n2) do
    %{
      "user_id" => owner.id,
      "title" => "My Match",
      "description" => "Match description",
      "match_time" => DateTime.utc_now() |> DateTime.to_string(),
      "type" => "real",
      # 1 hour
      "timer" => 3600,
      "arena_id" => 1,
      "min_player_frobot" => 1,
      "max_player_frobot" => 3,
      "slots" => [
        %{
          "frobot_id" => n1,
          "status" => "ready",
          "slot_type" => "host"
        },
        %{
          "frobot_id" => n2,
          "status" => "ready",
          "slot_type" => "protobot"
        },
        %{
          "status" => "open"
        },
        %{
          "status" => "closed"
        }
      ]
    }
  end

  test "get frobot details" do
    {:ok, myuser} = user_fixture()
    # currently fixtures only create prototype bots. (non-equipped)
    _frobot1 =
      Frobots.AssetsFixtures.frobot_fixture(myuser, %{
        name: "sniper",
        brain_code: "return()",
        class: Frobots.Assets.prototype_class()
      })

    _frobot2 =
      Frobots.AssetsFixtures.frobot_fixture(myuser, %{
        name: "necron99",
        brain_code: "return()",
        class: Frobots.Assets.prototype_class()
      })

    assert {:ok, _details} = Api.get_frobot_details("sniper")
    assert {:ok, _details} = Api.get_frobot_details("necron99")
  end

  describe "tournaments" do
    test "create tournament" do
      attrs = %{
        arena_id: 1,
        name: "tournament_aug",
        starts_at: System.os_time(:second) + 24 * 60 * 60,
        description: "Test Tournament for August",
        prizes: [50, 30, 20],
        commission_percent: 0,
        arena_fees_percent: 0,
        bonus_percent: 0,
        entry_fees: 0,
        participants: 64,
        status: :open
      }

      {:ok, tournament} = Api.create_tournament(attrs)
      assert tournament.status == :open
      assert is_integer(tournament.id)
      assert tournament.name == "tournament_aug"

      Process.sleep(2_000)
      ## Tournament Process is started
      assert "tournament#{tournament.id}"
             |> String.to_atom()
             |> Process.whereis()
             |> Process.alive?()
    end
  end

  # need to add a test for Api.create_frobot()
  # and then augment the frobot_fixtures with a version which is takes as arg the class, and does the right thing (create low level or create API level and equip all default equipment)
end
