defmodule Frobots.Repo.Migrations.RenameUsersToUsersOld do
  use Ecto.Migration

  def change do
    # rename
    rename table(:users), to: table(:users_old)
    drop index("users", [:name])
    drop index("frobots", [:user_id])
  end
end
