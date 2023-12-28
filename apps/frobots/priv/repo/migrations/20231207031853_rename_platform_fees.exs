defmodule Frobots.Repo.Migrations.RenamePlatformFees do
  use Ecto.Migration

  def change do
    rename table("tournaments"), :platform_fees, to: :bonus_percent
  end
end
