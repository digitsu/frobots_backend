defmodule Frobots.Repo.Migrations.CopyDataFromUsersOldToUsers do
  use Ecto.Migration

  def up do
    execute "insert into users
          (name, email,hashed_password_old,admin,active,inserted_at,updated_at, hashed_password, migrated_user )
          select name, username, password_hash,admin,active, inserted_at, updated_at, 'dummy', true
          from users_old"
    # migrate the user_id of frobots table to point to the new user id
    execute "WITH r AS ( select uo.id as old_id, uo.username, u.email, u.id as new_id, f.id as frobot_id, f.name frobot_name, f.user_id as current_user_id FROM users_old uo, users u, frobots f WHERE uo.id = f.user_id AND uo.username = u.email)
    UPDATE frobots SET user_id = r.new_id FROM r WHERE frobots.id = r.frobot_id RETURNING frobots.id, frobots.name, frobots.user_id"
  end

  def down do
    execute "delete from users where migrated_user=true"
    # revert the user_id migration
    execute "WITH r AS (select uo.id as old_id, uo.username, u.email, u.id as new_id, f.id as frobot_id, f.name frobot_name, f.user_id as current_user_id FROM users_old uo, users u, frobots f WHERE u.id = f.user_id AND
    uo.username = u.email)
    UPDATE frobots SET user_id = r.old_id FROM r WHERE frobots.id = r.frobot_id RETURNING frobots.id, frobots.name, frobots.user_id"
  end
end
