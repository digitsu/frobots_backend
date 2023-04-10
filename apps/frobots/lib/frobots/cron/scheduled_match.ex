defmodule Frobots.Cron.ScheduledMatch do
  use GenServer

  alias Frobots.Api
  alias Frobots.MatchChannel

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

  @impl true
  def handle_info(:start_match, state) do
    # Process.send_after(self(), :start_match, 5_000)
    Api.list_match_by(match_status: :pending, match_type: :real, match_time: DateTime.utc_now())
    |> Enum.each(fn match ->
      MatchChannel.start_match(match.id)
    end)

    {:noreply, state}
  end
end
