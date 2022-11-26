defmodule FrobotsWeb.RefreshSendgridContacts do
  use GenServer
  alias FrobotsWeb.SendInvites

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:refresh, state) do
    refresh_list()
    # Reschedule once more
    schedule_work()
    {:noreply, state}
  end

  def refresh_list() do
    # true -> just a dry run ..emails will not be sent
    # false -> this is the real thing..emails will be sent
    SendInvites.launch_beta(false)
  end

  defp schedule_work() do
    # change this to reload every 24 hrs..  24 * 24 * 60
    # every 3 mins
    Process.send_after(self(), :refresh, 180_000)
  end
end
