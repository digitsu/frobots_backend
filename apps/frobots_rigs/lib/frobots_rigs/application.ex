defmodule FrobotsRigs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Application...FROBOTS Rigs")
    options = [
      cache: Operate.Cache.ConCache,
      tape_adapter: Operate.Adapter.Bob,
      op_adapter: Operate.Adapter.Bob,
      extensions: [FrobotsRigs.Extension],
    ]

    children = [
      # Starts a worker by calling: FrobotsRigs.Worker.start_link(arg)
      # {FrobotsRigs.Worker, arg}
      {Operate, options},
      {ConCache, [
        name: :operate,
        ttl_check_interval: :timer.minutes(1),
        global_ttl: :timer.minutes(10),
        touch_on_read: true ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FrobotsRigs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
