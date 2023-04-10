defmodule Frobots.Cron.JoiningStatus do
  use GenServer

  @name __MODULE__
  require Logger

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    status_reset_interval = Application.get_env(:frobots, :status_reset_interval)
    Process.send_after(self(), :joining_status, 5_000)
    {:ok, %{status_reset_interval: status_reset_interval}}
  end

  def handle_info(:joining_status, state) do
    IO.inspect("Joining Status Handle Info")
    Process.send_after(self(), :joining_status, 5_000)
    {:noreply, state}
  end
end
