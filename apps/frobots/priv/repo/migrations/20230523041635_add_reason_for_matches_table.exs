defmodule Frobots.Repo.Migrations.AddReasonForMatchesTable do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :reason, :string
    end
  end
end
