defmodule Frobots.Tournaments do
  @moduledoc """
  The Tournaments Genserver.
  """

  use GenServer
  require Logger

  ## GenServer API

  def start_link(tournament_id) do
    GenServer.start_link(__MODULE__, tournament_id,
      name: String.to_atom("tournament#{tournament_id}")
    )
  end

  @doc """
  This function will be called by the supervisor to retrieve the specification
  of the child process.The child process is configured to restart only if it
  terminates abnormally.
  """
  def child_spec(tournament_id) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [tournament_id]},
      restart: :transient
    }
  end

  def stop(pid, stop_reason) do
    GenServer.stop(pid, stop_reason)
  end

  ## GenServer Callbacks

  @impl true
  def init(tournament_id) do
    Logger.info("Starting process for #{tournament_id}")
    ## Get the timer from scheduled time of tournament
    tournament = Frobots.Events.get_tournament(tournament_id)

    start_after = tournament.starts_at - System.os_time(:second)
    Process.send_after(self(), :create_matches, start_after)
    {:ok, %{tournament: tournament}}
  end

  @impl true
  def handle_info(:create_matches, %{tournament: tournament} = state) do
    Logger.info("create matches for tournament #{tournament.id}")
    {:noreply, state}
  end

  defp get_tournament_pool(participants) do
    number_of_pools_matches = :math.log2(participants)

    cond do
      number_of_pools_matches > 32 -> :pool_a
      number_of_pools_matches > 16 -> :pool_b
      number_of_pools_matches > 8 -> :pool_c
      number_of_pools_matches > 4 -> :quarter_final
      number_of_pools_matches > 2 -> :semi_final
      number_of_pools_matches == 2 -> :final
    end
  end

  # Each FROBOT plays each other in scheduled matches in each pool.
  # Wins score a 5.
  # Ties (timeout) score a 3
  # Losses score a 1
  defp pairing(_tournament_id, :pool_a) do
    # Get the tournament match type from tournament_players ordered by rank
    frobot_ids = []

    pairing =
      Enum.reduce([0..(length(frobot_ids) / 2 - 1)], [], fn index, acc ->
        [{Enum.at(frobot_ids, index), Enum.at(frobot_ids, length(frobot_ids) - 1 - index)} | acc]
      end)

    ## Logic for ordered pairing
    _ordered_pairing = pairing
  end
end
