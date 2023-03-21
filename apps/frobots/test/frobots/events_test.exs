defmodule Frobots.EventsTest do
  use Frobots.DataCase, async: true
  alias Frobots.Events
  alias Frobots.Agents.WinnersBucket

  describe "Match record tests" do
    alias Frobots.Assets.Frobot

    test "BASIC: create a match and battlelog" do
      {:ok, owner} = user_fixture()
      %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
      %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})
      %Frobot{id: n3} = frobot_fixture(owner, %{name: "rook"})
      %Frobot{id: n4} = frobot_fixture(owner, %{name: "tracker"})

      params = %{
        winners: ["random#1", "tracker#1"],
        qudos_pool: 100,
        payouts: [90, 10],
        odds: [0.1, 0.6, 0.3, 0.8],
        commission_paid: 20,
        frobots: [n1, n2, n3, n4]
      }

      {:ok, mt} = match_fixture()
      {:ok, bl} = Events.create_battlelog(mt, params)
      assert bl
    end
  end

  describe "Match" do
    test "create a match" do
      alias Frobots.Assets.Frobot

      {:ok, owner} = user_fixture()
      %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
      %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})

      params =
        %{
          "user_id" => owner.id,
          "title" => "My Match",
          "description" => "Match description",
          "match_time" =>  DateTime.utc_now() |> DateTime.to_string(),
          "timer" =>  3600, # 1 hour
          "arena_id" =>  1,
          "min_player_frobot" =>  1,
          "max_player_frobot" =>  3,
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
              "frobot_id" => nil,
              "status" => "closed",
              "slot_type" => "closed"
            }
          ],
          "match_template" => %{
            "entry_fee" => 100,
            "commission_rate" => 10,
            "match_type" => "team",
            "payout_map" => [100],
            "max_frobots" => 3,
            "min_frobots" => 1
          }
        }

      {:ok,  match} = Frobots.Events.create_match(params)
      assert is_integer(match.id)
      assert length(match.slots) == 3
      assert match.status == :pending
    end
  end

end
