defmodule Frobots.AvatarsTest do
  use Frobots.DataCase, async: true

  alias Frobots.Avatars

  describe "Frobots" do
    test "Get list of frobot avatar" do
      avatars = Avatars.get_frobot_avatars()

      assert Enum.count(avatars) > 0

      item = Enum.at(avatars, 0)
      assert item.id == 1
      assert item.avatar == "images/frobots/1.png"
    end
  end
end
