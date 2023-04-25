defmodule Frobots.LeaderboardTest do
  use Frobots.DataCase, async: false
  use ExUnit.Case, async: false
  alias Frobots.{Events, Assets, Leaderboard}
  alias Fubars.Match

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Frobots.Repo)
    # NOTE: Unless sandbox mode is auto. Postgres triggers are not firing
    Ecto.Adapters.SQL.Sandbox.mode(Frobots.Repo, :auto)

    {:ok, userbill} = Frobots.AccountsFixtures.user_fixture(%{name: "billy"})
    {:ok, userbob} = Frobots.AccountsFixtures.user_fixture(%{name: "bobby"})
    {:ok, userrobot} = Frobots.AccountsFixtures.user_fixture(%{name: "robby robot"})

    frobots_pool = [
      Frobots.AssetsFixtures.frobot_fixture(
        userbill,
        %{
          name: "suicide1",
          brain_code: ~s'return function(state, ...)
          state = state or {}
          state.type = "suicidal"
          glory()
          return state
        end',
          class: Assets.default_user_class()
        }
      ),
      Frobots.AssetsFixtures.frobot_fixture(
        userbob,
        %{
          name: "normal1",
          brain_code: ~s'return function(state, ...)
          state = state or {}
          state.type = "normal"

          return state
        end',
          class: Assets.default_user_class()
        }
      ),
      Frobots.AssetsFixtures.frobot_fixture(
        userrobot,
        %{
          name: "NPC1",
          brain_code: ~s'return function(state, ...)
          state = state or {}
          -- do nothing
          state.type = "happy"
          return state
        end',
          class: Assets.prototype_class()
        }
      )
    ]

    match_template = %{
      "entry_fee" => 100,
      "commission_rate" => 10,
      "match_type" => "individual",
      "winners" => ["suicide1#1"],
      "payout_map" => [100],
      "max_frobots" => 4,
      "min_frobots" => 2
    }

    on_exit(fn ->
      IO.inspect("Resetting sandbox mode back to :shared")
      Ecto.Adapters.SQL.Sandbox.mode(Frobots.Repo, {:shared, self()})
    end)

    frobots = Enum.map(frobots_pool, fn x -> %{"id" => x.id, "name" => x.name} end)
    %{frobots: frobots, match_template: match_template, user: userbill}
  end

  def wait_for_down(ref) do
    receive do
      {:DOWN, ^ref, _key, _pid, _reason} ->
        :rig_is_down
    after
      # Optional timeout
      10_000 -> :timeout
    end
  end

  test "verify leaderboard stats is populated", %{
    frobots: frobots,
    user: user,
    match_template: match_template
  } do
    start_and_wait_for_match("200", user, "suicide1", match_template, frobots)
    :timer.sleep(2_000)
    stats = Leaderboard.get_stats()
    assert Enum.count(stats) == 1
    stat = Enum.at(stats, 0)
    assert stat.points == 10
    assert stat.matches_participated == 1
    assert stat.matches_won == 1

    start_and_wait_for_match("201", user, "suicide1", match_template, frobots)
    :timer.sleep(2_000)
    stats = Leaderboard.get_stats()
    assert Enum.count(stats) == 1
    stat = Enum.at(stats, 0)
    assert stat.points == 15
    assert stat.matches_participated == 2
    assert stat.matches_won == 2
  end

  def start_and_wait_for_match(match, user, winner, match_template, frobots) do
    winner = "#{winner}" <> "#" <> "1"

    match_template = Map.replace(match_template, "winners", [winner])

    {:ok, match_name} =
      Fubars.Match.Supervisor.init_match(
        match,
        nil,
        1_000
      )

    allow = Process.whereis(match_name)
    Ecto.Adapters.SQL.Sandbox.allow(Frobots.Repo, self(), allow)

    ref = Process.monitor(match_name)
    frobots = [Enum.at(frobots, 1), Enum.at(frobots, 2)]
    match_data = Enum.into(%{"frobots" => frobots}, match_template)

    slots =
      Enum.map(frobots, fn frobot ->
        %{
          "frobot_id" => frobot["id"],
          "status" => "ready",
          "slot_type" => "host"
        }
      end)

    match_data =
      Map.merge(
        match_data,
        %{
          "user_id" => user.id,
          "match_time" => DateTime.utc_now(),
          "timer" => 1,
          "arena_id" => 1,
          "min_player_frobot" => 1,
          "max_player_frobot" => 5,
          "slots" => slots
        }
      )

    {:ok, _frobots_map} = Match.start_match(match_name, match_data)

    id = :sys.get_state(match_name).match.id
    mon = wait_for_down(ref)
    assert mon == :rig_is_down
    match_record = Events.get_match_by(id: id)
    assert match_record.status == :done
  end
end
