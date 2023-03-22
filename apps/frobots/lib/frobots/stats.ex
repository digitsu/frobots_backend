defmodule Frobots.Stats do
  alias Frobots.{Accounts, Events, Assets}

  def get_user_stats(%Accounts.User{} = user) do
    user_frobots = Assets.list_user_frobots(user)

    total_xp =
      Enum.reduce(user_frobots, 0, fn x, acc ->
        if is_nil(x.xp) do
          acc
        else
          x.xp + acc
        end
      end)

    frobot_ids = Enum.map(user_frobots, fn x -> x.id end)
    match_participation_count = Events.get_match_participation_count(frobot_ids)

    # return map

    %UserStats{
      frobots_count: Enum.count(user_frobots),
      total_xp: total_xp,
      matches_participated: match_participation_count,
      upcoming_matches: 0
    }
  end
end
