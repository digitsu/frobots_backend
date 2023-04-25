defmodule Frobots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Frobots.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Frobots.PubSub},
      # Start a worker by calling: Frobots.Worker.start_link(arg)
      # {Frobots.Worker, arg}
      Frobots.Agents.WinnersBucket,
      Frobots.DatabaseListener,
      Frobots.MatchChannel,
      Frobots.Cron.ScheduledMatch,
      Frobots.Cron.JoiningStatus
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Frobots.Supervisor)
  end
end
