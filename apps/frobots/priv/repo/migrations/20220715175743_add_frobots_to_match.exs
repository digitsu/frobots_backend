defmodule Frobots.Repo.Migrations.AddFrobotsToMatch do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :frobots, {:array, :integer}
    end
  end
end
