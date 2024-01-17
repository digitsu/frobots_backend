defmodule FrobotsWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Appsignal.Phoenix.LiveView.attach()

    children = [
      # Start the Telemetry supervisor
      FrobotsWeb.Telemetry,
      # Start the Endpoint (http/https)
      FrobotsWeb.Endpoint,
      # Start a worker by calling: FrobotsWeb.Worker.start_link(arg)
      # {FrobotsWeb.Worker, arg}
      {ConCache,
       [
         name: :frobots_web,
         ttl_check_interval: :timer.minutes(1),
         global_ttl: :timer.minutes(10),
         touch_on_read: true
       ]},
      FrobotsWeb.RefreshSendgridContacts,
      FrobotsWeb.Presence
    ]

    # update all templates from source code
    # Frobots.update_all_templates()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FrobotsWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FrobotsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
