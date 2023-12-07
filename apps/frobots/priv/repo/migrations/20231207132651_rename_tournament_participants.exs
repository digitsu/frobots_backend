defmodule Frobots.Repo.Migrations.RenameTournamentParticipants do
  use Ecto.Migration

  def change do
    rename table("tournaments"), :participants, to: :min_participants
  end
end
