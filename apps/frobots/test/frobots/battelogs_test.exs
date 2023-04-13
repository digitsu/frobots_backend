defmodule Frobots.BattleLogsTest do
  use Frobots.DataCase, async: true
  alias Frobots.Events
  alias Frobots.Assets
  alias Frobots.Agents.WinnersBucket

  def create_battelog_fixtures(match_template, params, count) do
    Enum.to_list(1..count)
    |> Enum.map(fn _x ->
      {:ok, _bl} = battlelog_fixture(match_template, params)
    end)
  end

  describe "Fetch leaderboard entries" do
    alias Frobots.Assets.Frobot

    test "verify list of entries is returned" do
      {:ok, owner} = user_fixture()
      %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
      %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})
      %Frobot{id: n3} = frobot_fixture(owner, %{name: "rook"})
      %Frobot{id: n4} = frobot_fixture(owner, %{name: "tracker"})

      params1 = %{
        winners: ["rook#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [n1, n2, n3, n4]
      }

      params2 = %{
        winners: ["rook#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [n1, n2, n3, n4]
      }

      params3 = %{
        winners: ["tracker#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [n1, n2, n3, n4]
      }

      {:ok, mt} =
        match_fixture(%{
          "status" => "done",
          "user_id" => owner.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "type" => "real"
        })

      {:ok, bl1} = battlelog_fixture(mt, params1)
      assert bl1
      {:ok, bl2} = battlelog_fixture(mt, params2)
      assert bl2

      {:ok, bl3} = battlelog_fixture(mt, params3)
      assert bl3

      # call Events.prep_leaderboard_entries()
      Events.prep_leaderboard_entries()

      resp = Events.send_leaderboard_entries()
      # assert list is returned

      assert is_list(resp)
      # assert shape of data
      item1 = Enum.at(resp, 0)

      # assert structure
      assert Map.has_key?(item1, :attempts)
      assert Map.has_key?(item1, :points)
      assert Map.has_key?(item1, :username)
      assert Map.has_key?(item1, :rank)

      # assert values
      assert Map.get(item1, :points) == 15.0
      assert Map.get(item1, :attempts) == 2
      assert Map.get(item1, :rank) == 1

      item2 = Enum.at(resp, 1)
      assert Map.get(item2, :points) == 10.0
      assert Map.get(item2, :attempts) == 1
      assert Map.get(item2, :rank) == 2
    end

    test "verify user frobots stats are returned" do
      # user 1
      {:ok, owner1} = user_fixture(%{email: unique_user_email()})

      frobot1 = frobot_fixture(owner1, %{name: "rabbit", xp: 10})
      frobot2 = frobot_fixture(owner1, %{name: "random", xp: 10})
      frobot3 = frobot_fixture(owner1, %{name: "rook", xp: 10})
      frobot4 = frobot_fixture(owner1, %{name: "tracker", xp: 10})

      params1 = %{
        winners: ["tracker#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [frobot1.name, frobot2.name, frobot3.name, frobot4.name]
      }

      {:ok, mt1} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot1.name, "id" => frobot1.id},
            %{"name" => frobot2.name, "id" => frobot2.id},
            %{"name" => frobot3.name, "id" => frobot3.id},
            %{"name" => frobot4.name, "id" => frobot4.id}
          ]
        })

      # user 2
      {:ok, owner2} = user_fixture(%{email: unique_user_email()})

      frobot5 = frobot_fixture(owner2, %{name: "ninja", xp: 10})
      frobot6 = frobot_fixture(owner2, %{name: "asassin", xp: 10})
      frobot7 = frobot_fixture(owner2, %{name: "bait", xp: 10})
      frobot8 = frobot_fixture(owner2, %{name: "striker", xp: 10})

      params2 = %{
        winners: ["ninja#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [frobot5.name, frobot6.name, frobot7.name, frobot8.name]
      }

      {:ok, mt2} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot5.name, "id" => frobot5.id},
            %{"name" => frobot6.name, "id" => frobot6.id},
            %{"name" => frobot7.name, "id" => frobot7.id},
            %{"name" => frobot8.name, "id" => frobot8.id}
          ]
        })

      # create battlelogs
      create_battelog_fixtures(mt1, params1, 5)
      create_battelog_fixtures(mt2, params2, 5)

      Events.prep_leaderboard_entries()
      leaderboard_entries = Events.send_leaderboard_entries()

      entry1 = Enum.at(leaderboard_entries, 0)
      assert entry1.xp == 10
      assert entry1.frobot == "tracker"
      assert entry1.matches_participated == 1
      assert entry1.matches_won == 1

      entry2 = Enum.at(leaderboard_entries, 1)
      assert entry2.xp == 10
      assert entry2.frobot == "ninja"
      assert entry2.matches_participated == 1
      assert entry2.matches_won == 1
    end

    test "verify player leaderboardstats are returned" do
      {:ok, owner1} = user_fixture(%{email: unique_user_email(), name: "user1"})

      frobot1 = frobot_fixture(owner1, %{name: "rabbit", xp: 10})
      frobot2 = frobot_fixture(owner1, %{name: "random", xp: 10})
      frobot3 = frobot_fixture(owner1, %{name: "rook", xp: 10})
      frobot4 = frobot_fixture(owner1, %{name: "tracker", xp: 10})

      params1 = %{
        winners: ["tracker#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [frobot1.name, frobot2.name, frobot3.name, frobot4.name]
      }

      {:ok, mt1} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot1.name, "id" => frobot1.id},
            %{"name" => frobot2.name, "id" => frobot2.id},
            %{"name" => frobot3.name, "id" => frobot3.id},
            %{"name" => frobot4.name, "id" => frobot4.id}
          ]
        })

      # user 2
      {:ok, owner2} = user_fixture(%{email: unique_user_email(), name: "user2"})

      frobot5 = frobot_fixture(owner2, %{name: "ninja", xp: 10})
      frobot6 = frobot_fixture(owner2, %{name: "asassin", xp: 10})
      frobot7 = frobot_fixture(owner2, %{name: "bait", xp: 10})
      frobot8 = frobot_fixture(owner2, %{name: "striker", xp: 10})

      params2 = %{
        winners: ["ninja#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [frobot5.name, frobot6.name, frobot7.name, frobot8.name]
      }

      {:ok, mt2} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot5.name, "id" => frobot5.id},
            %{"name" => frobot6.name, "id" => frobot6.id},
            %{"name" => frobot7.name, "id" => frobot7.id},
            %{"name" => frobot8.name, "id" => frobot8.id}
          ]
        })

      {:ok, mt3} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot1.name, "id" => frobot1.id},
            %{"name" => frobot2.name, "id" => frobot2.id},
            %{"name" => frobot3.name, "id" => frobot3.id},
            %{"name" => frobot4.name, "id" => frobot4.id}
          ]
        })

      # user2 did not win
      {:ok, mt4} =
        match_fixture(%{
          "user_id" => owner1.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 2,
          "max_player_frobot" => 4,
          "status" => "done",
          "type" => "real",
          "frobots" => [
            %{"name" => frobot4.name, "id" => frobot4.id},
            %{"name" => frobot5.name, "id" => frobot5.id},
            %{"name" => frobot6.name, "id" => frobot6.id},
            %{"name" => frobot1.name, "id" => frobot1.id}
          ]
        })

      params4 = %{
        winners: ["tracker#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [frobot4.name, frobot5.name, frobot6.name, frobot1.name]
      }

      # create battlelogs
      create_battelog_fixtures(mt1, params1, 3)
      create_battelog_fixtures(mt2, params2, 3)
      create_battelog_fixtures(mt1, params1, 3)
      create_battelog_fixtures(mt3, params1, 3)
      create_battelog_fixtures(mt4, params4, 3)

      Events.prep_leaderboard_entries()
      leaderboard_entries = Events.send_player_leaderboard_entries()

      entry1 = Enum.at(leaderboard_entries, 0)
      # assert entry1.xp == 10
      assert entry1.username == "user1"
      assert entry1.matches_participated == 3
      assert entry1.matches_won == 3
      assert entry1.xp == 40
      assert entry1.rank == 1

      entry2 = Enum.at(leaderboard_entries, 1)
      assert entry2.username == "user2"
      assert entry2.matches_participated == 2
      assert entry2.matches_won == 1
      assert entry2.xp == 40
      assert entry2.rank == 2
    end
  end
end
