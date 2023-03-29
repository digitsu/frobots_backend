defmodule Frobots.ApiTest do
  use Frobots.DataCase, async: true
  alias Frobots.Api
  alias Frobots.Assets.Frobot

  test "list matches by pagination" do
    {:ok, owner} = user_fixture()
    %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
    %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})

    params = create_match_params(owner, n1, n2)
    {:ok, _created_match} = Api.create_match(params)

    assert %{entries: matches, page_number: 1} = Api.list_paginated_matches(status: :pending)

    assert Enum.all?(matches, fn match -> match.status == :pending end)
  end

  test "list matches by pagination with searching" do
    {:ok, owner} = user_fixture()
    %Frobot{id: n1} = frobot_fixture(owner, %{name: "rabbit"})
    %Frobot{id: n2} = frobot_fixture(owner, %{name: "random"})

    params = create_match_params(owner, n1, n2)
    {:ok, _created_match} = Api.create_match(params)

    assert %{entries: matches, page_number: 1} =
             Api.list_paginated_matches(status: :pending, search_pattern: "my")

    assert length(matches) > 0
    assert Enum.all?(matches, fn match -> match.status == :pending end)

    ## Match not found with this pattern
    assert %{entries: matches, page_number: 1} =
             Api.list_paginated_matches(status: :pending, search_pattern: "bb")

    assert length(matches) == 0
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
      ]
    }
  end
end
