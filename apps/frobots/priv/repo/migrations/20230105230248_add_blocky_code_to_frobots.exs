defmodule Frobots.Repo.Migrations.AddBlockyCodeToFrobots do
  use Ecto.Migration

  def change do
    alter table(:frobots) do
      add :blockly_code, :text
    end
  end
end
