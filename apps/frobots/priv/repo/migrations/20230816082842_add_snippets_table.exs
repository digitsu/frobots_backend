defmodule Frobots.Repo.Migrations.AddSnippetsTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:snippets) do
      add :user_id, references(:users, on_delete: :nothing)
      add :code, :text
      add :name, :string

      timestamps()
    end
  end
end
