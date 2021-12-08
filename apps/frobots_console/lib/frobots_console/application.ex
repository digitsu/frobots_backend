defmodule FrobotsConsole.Application do
  require Logger
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    Logger.info("Starting Application...FROBOTS Console")

    children = [
      # Starts a worker by calling: FrobotsConsole.Worker.start_link(arg)
      # {FrobotsConsole.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FrobotsConsole.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
