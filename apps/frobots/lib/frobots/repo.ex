defmodule Frobots.Repo do
  use Ecto.Repo,
    otp_app: :frobots,
    adapter: Ecto.Adapters.Postgres
end
