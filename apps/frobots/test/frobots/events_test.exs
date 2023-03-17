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
end
