defmodule FrobotsWeb.MatchChannelTest do
  use FrobotsWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      FrobotsWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(FrobotsWeb.MatchChannel, "match:lobby")

    %{socket: socket}
  end

  # todo need to add a test for start_match

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
