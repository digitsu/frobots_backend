defmodule Frobots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Application...FROBOTS")

    children = [
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Frobots.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
