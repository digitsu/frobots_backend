defmodule Frobots.Repo.Migrations.RenameUsersToUsersOld do
  use Ecto.Migration

  def up do
    # drop the indexes
    drop_if_exists index("users", [:username])
    drop_if_exists index("frobots", [:user_id])
    # rename
    rename table(:users), to: table(:users_old)
  end

  def down do
    rename table(:users_old), to: table(:users)
    create_if_not_exists unique_index(:users, [:username])
    # create unique_index(:users, [:name])
    # drop_if_exists index(:frobots, [:user_id])
    # execute "insert into users
    # (name, email,hashed_password_old,admin,active,inserted_at,updated_at, hashed_password, migrated_user )
    # select name, username, password_hash,admin,active, inserted_at, updated_at, 'dummy', true
    # from users_old"
    # create unique_index(:frobots, [:user_id])
  end
end
