defmodule Frobots.Cron.JoiningStatus do
  use GenServer

  @name __MODULE__
  alias Frobots.Repo
  alias Frobots.Events.{Match, Slot}
  import Ecto.Query

  require Logger

  def start_link(_opts) do
    GenServer.start_link(@name, [], name: @name)
  end

  @impl true
  def init(_args) do
    status_reset_interval = Application.get_env(:frobots, :status_reset_interval)
    cron_interval = Application.get_env(:frobots, :cron_interval) * 1_000
    Process.send_after(self(), :joining_status, cron_interval)
    Process.send_after(self(), :running_status, cron_interval)
    {:ok, %{status_reset_interval: status_reset_interval, cron_interval: cron_interval}}
  end

  @impl true
  def handle_info(
        :joining_status,
        %{cron_interval: cron_interval, status_reset_interval: status_reset_interval} = state
      ) do
    Process.send_after(self(), :joining_status, cron_interval)
    status_reset_time = DateTime.utc_now() |> DateTime.add(-1 * status_reset_interval)

    query = from(s in Slot, where: s.status == :joining and s.updated_at <= ^status_reset_time)

    joining_status = query |> Repo.all()
    if length(joining_status) > 0, do: query |> Repo.update_all(set: [status: :open])

    {:noreply, state}
  end

  @impl true
  def handle_info(
        :running_status,
        %{cron_interval: cron_interval} = state
      ) do
    Process.send_after(self(), :running_status, cron_interval)
    now = System.os_time(:second)

    query =
      from(m in Match,
        where: m.status == :running and fragment("? + ?", m.started_at, m.timer) <= ^now
      )

    running_status = query |> Repo.all()

    if length(running_status) > 0 do
      query |> Repo.update_all(set: [status: :cancelled])
      match_ids = Enum.map(running_status, fn m -> m.id end)

      from(s in Slot, where: s.match_id in ^match_ids)
      |> Repo.update_all(set: [status: :cancelled])
    end

    {:noreply, state}
  end
end
