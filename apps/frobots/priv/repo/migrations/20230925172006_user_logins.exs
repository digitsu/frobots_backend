defmodule Frobots.Repo.Migrations.UserLogins do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:user_logins) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps(updated_at: false)
    end
  end
end
