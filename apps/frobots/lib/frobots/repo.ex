defmodule Frobots.Repo do
  use Ecto.Repo,
    otp_app: :frobots,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 15
end
