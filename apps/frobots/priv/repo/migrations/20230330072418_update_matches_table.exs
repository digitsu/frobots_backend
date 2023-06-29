defmodule Frobots.Repo.Migrations.UpdateMatchesTable do
  use Ecto.Migration

  def up do
    execute(
      "update matches m SET user_id = (select id from users where name = 'god' and email = 'frobots'), match_time = inserted_at, timer = 3600, arena_id = 1, min_player_frobot = CAST (match_template ->> 'min_frobots' AS INTEGER), max_player_frobot = CAST (match_template ->> 'max_frobots' AS INTEGER);"
    )
  end

  def down do
    IO.puts("Nothing to Rollback;")
  end
end
