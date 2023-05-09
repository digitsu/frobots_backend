defmodule Frobots.Repo.Migrations.CreateViewSummaryPlayerLeaderboard do
  use Ecto.Migration

  def up do
    execute """
    create or replace view leaderboard_stats_view as
      select
        ls.user_id,
        (select sum(ls1.xp) from leaderboard_stats ls1 where ls1.user_id = ls.user_id) as xp,
        (select sum(ls1.points) from leaderboard_stats ls1 where ls1.user_id = ls.user_id) as points,
        (select sum(ls1.matches_participated) from leaderboard_stats ls1 where ls1.user_id = ls.user_id) as matches_participated,
        (select sum(ls1.matches_won) from leaderboard_stats ls1 where ls1.user_id = ls.user_id) as matches_won,
        (select sum(ls1.attempts) from leaderboard_stats ls1 where ls1.user_id = ls.user_id) as attempts
      from
        leaderboard_stats ls
      group by
        ls.user_id;
    """
  end

  def down do
    execute """
      drop view leaderboard_stats_view
    """
  end
end
