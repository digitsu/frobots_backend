defmodule Frobots.Repo.Migrations.AddXpForMatchesTable do
  use Ecto.Migration

  def change do
    alter table(:battlelogs) do
      add :xp, :json
    end
  end
end
