defmodule Frobots.Tournaments do
  @moduledoc """
  The Tournaments Genserver.
  """

  use GenServer
  require Logger
  alias Frobots.Accounts

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
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    admin_user = Accounts.get_user_by(name: Accounts.admin_user_name())

    start_after = tournament.starts_at - System.os_time(:second) + 10
    Process.send_after(self(), :pool_matches, start_after)
    {:ok, %{tournament: tournament, admin_user: admin_user}}
  end

  @impl true
  def handle_info(:pool_matches, %{tournament: tournament, admin_user: admin_user} = state) do
    Logger.info("Create Pools for Tournament #{tournament.id}")
    participants = length(tournament.tournament_players)

    participant_per_pool = 5
    number_of_pools = div(participants, participant_per_pool)
    reminder = rem(participants, participant_per_pool)

    number_of_fully_filled_pools = number_of_pools - (participant_per_pool - reminder - 1)
    number_of_partially_filled_pools = number_of_pools + 1 - number_of_fully_filled_pools

    {fully_filled_pools, partially_filled_pools} =
      cond do
        number_of_partially_filled_pools > 0 and length(tournament.tournament_players) > 0 ->
          [fully_filled_pools_participants, partially_filled_pools_participants] =
            Enum.chunk_every(
              tournament.tournament_players,
              number_of_fully_filled_pools * participant_per_pool
            )

          fully_filled_pools =
            Enum.chunk_every(fully_filled_pools_participants, participant_per_pool)

          partially_filled_pools =
            Enum.chunk_every(partially_filled_pools_participants, participant_per_pool - 1)

          {fully_filled_pools, partially_filled_pools}

        length(tournament.tournament_players) > 0 ->
          fully_filled_pools =
            Enum.chunk_every(tournament.tournament_players, participant_per_pool)

          {fully_filled_pools, []}

        true ->
          {[], []}
      end

    total_index =
      Enum.reduce(fully_filled_pools, 1, fn pool_participants, index ->
        Enum.each(pool_participants, fn pool_participant ->
          {:ok, _} =
            Frobots.Events.update_tournament_players(pool_participant, %{match_sub_type: index})
        end)

        index + 1
      end)

    Enum.reduce(partially_filled_pools, total_index, fn pool_participants, index ->
      Enum.each(pool_participants, fn pool_participant ->
        {:ok, _} =
          Frobots.Events.update_tournament_players(pool_participant, %{match_sub_type: index})
      end)

      index + 1
    end)

    Enum.reduce(fully_filled_pools, {1, 1}, fn pool_participants, {pool_index, match_index} ->
      for x <- pool_participants, y <- pool_participants, x.id != y.id do
        if x.frobot_id < y.frobot_id do
          {x.frobot_id, y.frobot_id}
        else
          {y.frobot_id, x.frobot_id}
        end
      end
      |> Enum.uniq()
      |> Enum.reduce(match_index, fn {f1, f2}, match_index ->
        params =
          create_match_params("pool", pool_index, match_index, tournament, admin_user.id, f1, f2)

        {:ok, _match} = Frobots.Events.create_match(params)
        match_index + 1
      end)

      {pool_index + 1, match_index + 1}
    end)

    {:noreply, state |> Map.put(:pool_done, true)}
  end

  # @impl true
  # def handle_info(:create_matches, %{tournament: tournament} = state) do
  #   Logger.info("create matches for tournament #{tournament.id}")
  #   {:noreply, state}
  # end

  # defp get_tournament_pool(participants) do
  #   number_of_pools_matches = :math.log2(participants)

  #   cond do
  #     number_of_pools_matches > 32 -> :pool_a
  #     number_of_pools_matches > 16 -> :pool_b
  #     number_of_pools_matches > 8 -> :pool_c
  #     number_of_pools_matches > 4 -> :quarter_final
  #     number_of_pools_matches > 2 -> :semi_final
  #     number_of_pools_matches == 2 -> :final
  #   end
  # end

  # Each FROBOT plays each other in scheduled matches in each pool.
  # Wins score a 5.
  # Ties (timeout) score a 3
  # Losses score a 1
  def pairing(_tournament_id, :pool_a) do
    # Get the tournament match type from tournament_players ordered by rank
    frobot_ids = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

    max_range = div(length(frobot_ids), 2) - 1

    pairing =
      Enum.reduce(0..max_range, [], fn index, acc ->
        acc ++ [{Enum.at(frobot_ids, index), Enum.at(frobot_ids, length(frobot_ids) - 1 - index)}]
      end)

    ## Logic for ordered pairing
    max_range = div(length(pairing), 2) - 1

    _ordered_pairing =
      Enum.reduce(0..max_range, [], fn index, acc ->
        acc ++ [Enum.at(pairing, index), Enum.at(pairing, length(pairing) - 1 - index)]
      end)
  end

  defp create_match_params(match_type, match_sub_type, match_id, tournament, user_id, f1, f2) do
    %{
      "user_id" => user_id,
      "title" => "Match of #{tournament.name}",
      "description" => "Match of #{tournament.description}",
      ## Start After 30 mins
      "match_time" =>
        DateTime.utc_now() |> DateTime.add(30 * 60, :second) |> DateTime.to_string(),
      "type" => "real",
      "tournament_match_type" => match_type,
      "tournament_match_sub_type" => match_sub_type,
      "tournament_match_id" => match_id,
      "tournament_id" => tournament.id,
      # 10 mins
      "timer" => 600,
      "arena_id" => tournament.arena_id,
      "min_player_frobot" => 2,
      "max_player_frobot" => 2,
      "slots" => [
        %{
          "frobot_id" => f1,
          "status" => "ready",
          "slot_type" => "player"
        },
        %{
          "frobot_id" => f2,
          "status" => "ready",
          "slot_type" => "player"
        }
      ]
    }
  end
end
