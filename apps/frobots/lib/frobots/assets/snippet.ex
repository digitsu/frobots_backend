defmodule Frobots.Assets.Snippet do
  @moduledoc """
  The Snippet context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :code, :user_id]}

  schema "snippets" do
    field :name, :string
    field :code, :string
    belongs_to :user, Frobots.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(snippet, attrs \\ %{}) do
    snippet
    |> cast(attrs, [
      :code,
      :name,
      :user_id
    ])
    |> validate_required([:code, :name, :user_id])
  end
end
