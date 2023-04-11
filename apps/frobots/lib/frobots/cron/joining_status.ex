defmodule Frobots.Cron.JoiningStatus do
  use GenServer

  @name __MODULE__
  alias Frobots.Repo
  alias Frobots.Events.Slot
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
    {:ok, %{status_reset_interval: status_reset_interval, cron_interval: cron_interval}}
  end

  @impl true
  def handle_info(
        :joining_status,
        %{cron_interval: cron_interval, status_reset_interval: status_reset_interval} = state
      ) do
    Process.send_after(self(), :joining_status, cron_interval)
    status_reset_time = DateTime.utc_now() |> DateTime.add(status_reset_interval)

    from(s in Slot, where: s.status == 'joining' and s.inserted_at <= ^status_reset_time)
    |> Repo.update_all(set: [status: "open"])

    {:noreply, state}
  end
end
