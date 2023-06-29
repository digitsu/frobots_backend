defmodule FrobotsWeb.RefreshSendgridContacts do
  use GenServer
  alias FrobotsWeb.SendInvites
  #TODO this should be re-written as a Task! Do not patch this... just re-write it.

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
    if Application.get_env(:sendgrid, :send_email) == true do
      SendInvites.process_mailing_list()
    end
  end

  defp schedule_work() do
    # runs every 3 mins
    Process.send_after(self(), :refresh, 180_000)
  end
end
