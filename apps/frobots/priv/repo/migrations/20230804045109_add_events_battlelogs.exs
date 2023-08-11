defmodule Frobots.Repo.Migrations.AddEventsBattlelogs do
  use Ecto.Migration

  def change do
    alter table(:battlelogs) do
      add :events, :jsonb
    end
  end
end
