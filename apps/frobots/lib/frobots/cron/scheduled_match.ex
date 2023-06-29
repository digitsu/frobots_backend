defmodule Frobots.Cron.ScheduledMatch do
  @moduledoc """
  The ScheduledMatch context.
  """
  use GenServer
  @vsn 1

  alias Frobots.Api
  alias Frobots.MatchChannel

  @name __MODULE__
  require Logger

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    cron_interval = Application.get_env(:frobots, :cron_interval) * 1_000
    Process.send_after(self(), :start_match, cron_interval)
    {:ok, %{cron_interval: cron_interval}}
  end

  @impl true
  def handle_info(:start_match, %{cron_interval: cron_interval} = state) do
    Process.send_after(self(), :start_match, cron_interval)

    Api.list_match_by(match_status: :pending, match_type: :real, match_time: DateTime.utc_now())
    |> Enum.each(fn match ->
      MatchChannel.start_match(match.id)
    end)

    {:noreply, state}
  end
end
