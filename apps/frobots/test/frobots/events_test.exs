defmodule Frobots.EventsTest do
  use Frobots.DataCase, async: true
  alias Frobots.Events
  alias Frobots.Assets.Frobot

  describe "Match record tests" do
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

      {:ok, mt} =
        match_fixture(%{
          "user_id" => owner.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 3600,
          "arena_id" => 1,
          "min_player_frobot" => 1,
          "max_player_frobot" => 5,
          "status" => "done",
          "type" => "real"
        })

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

      params = create_match_params(owner, n1, n2)
      {:ok, match} = Frobots.Events.create_match(params)
      assert is_integer(match.id)
      assert length(match.slots) == 3
      assert match.status == :pending
    end

    test "get a match" do
      {:ok, owner} = user_fixture()
      %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
      %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})

      params = create_match_params(owner, n1, n2)

      {:ok, created_match} = Frobots.Events.create_match(params)
      assert [match] = Frobots.Events.list_match_by(id: created_match.id, status: :pending)

      assert created_match.id == match.id
      assert created_match.status == match.status
    end
  end

  defp create_match_params(owner, n1, n2) do
    %{
      "user_id" => owner.id,
      "title" => "My Match",
      "description" => "Match description",
      "match_time" => DateTime.utc_now() |> DateTime.to_string(),
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
          "status" => "closed"
        }
      ],
      "type" => "real",
      "frobot_ids" => [n1, n2],
      "match_template" => %{
        "entry_fee" => 0,
        "commission_rate" => 0,
        "match_type" => "individual",
        "payout_map" => [100],
        "max_frobots" => 3,
        "min_frobots" => 1
      }
    }
  end
end
