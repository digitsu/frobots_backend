defmodule Frobots.Cron.ScheduledMatch do
  use GenServer

  @name __MODULE__
  require Logger

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    Process.send_after(self(), :start_match, 5_000)
    {:ok, %{}}
  end

  def handle_info(:start_match, state) do
    IO.inspect("Start Match Handle Info")
    Process.send_after(self(), :start_match, 5_000)
    {:noreply, state}
  end
end
