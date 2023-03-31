defmodule Frobots.Repo.Migrations.AlterMatchesTableWithMatchType do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :type, :string
    end
  end
end
