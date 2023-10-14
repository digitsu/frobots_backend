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
    Logger.info("Starting Scheduled Match Cron")
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    cron_interval = Application.get_env(:frobots, :cron_interval) * 1_000
    Process.send_after(self(), :start_match, cron_interval * 30)
    Process.send_after(self(), :start_tournament_manager, cron_interval * 30)
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

  @impl true
  def handle_info(:start_tournament_manager, %{cron_interval: cron_interval} = state) do
    Process.send_after(self(), :start_tournament_manager, cron_interval * 10)

    (Frobots.Events.list_tournament_by([status: :open], []) ++
       Frobots.Events.list_tournament_by([status: :inprogress], []))
    |> Enum.each(fn tournament ->
      if is_nil(Process.whereis("tournament#{tournament.id}" |> String.to_atom())) do
        Frobots.TournamentManager.start_child(tournament.id)
      end
    end)

    {:noreply, state}
  end
end
