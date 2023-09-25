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

    start_after = (tournament.starts_at - System.os_time(:second) + 60) * 1000
    Process.send_after(self(), :pool_matches, start_after)
    {:ok, %{tournament_id: tournament_id, admin_user: admin_user}}
  end

  @impl true
  def handle_info(:pool_matches, %{tournament_id: tournament_id, admin_user: admin_user} = state) do
    Logger.info("Create Pools for Tournament #{tournament_id}")
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    participants = length(tournament.tournament_players) |> IO.inspect(label: "Participants")
    {number_of_fully_filled_pools, number_of_partially_filled_pools, participant_per_pool} = pool_mapper(participants)

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
            Enum.chunk_every(partially_filled_pools_participants, participant_per_pool + 1)

          {fully_filled_pools, partially_filled_pools}

        length(tournament.tournament_players) > 0 ->
          fully_filled_pools =
            Enum.chunk_every(tournament.tournament_players, participant_per_pool)

          {fully_filled_pools, []}

        true ->
          {[], []}
      end
      |> IO.inspect(label: "pools")

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
          Frobots.Events.update_tournament_players(pool_participant, %{tournament_match_sub_type: index})
      end)

      index + 1
    end)
    |> IO.inspect(label: "Updated Tournament Players")

    {_, match_index} =
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
            create_match_params(
              "pool",
              pool_index,
              match_index,
              tournament,
              admin_user.id,
              f1,
              f2
            )

          {:ok, _match} = Frobots.Events.create_match(params) |> IO.inspect(label: "Matches")
          match_index + 1
        end)

        {pool_index + 1, match_index + 1}
      end)

    ## Update Pool Matches Score after 12 Hours
    start_after = 12 * 60 * 60 * 1000
    Process.send_after(self(), {:update_score, :pool}, start_after)

    ## Start KnockOut Matches after 14 Hours
    start_after = 14 * 60 * 60 * 1000
    Process.send_after(self(), :knockout_matches, start_after)

    {:noreply, state |> Map.put(:match_index, match_index) |> Map.put(:tournament_id, tournament.id)}
  end

  @impl true
  def handle_info(
        {:update_score, tournament_match_type},
        %{tournament_id: tournament_id} = state
      ) do
    Logger.info("Update Score for Tournament #{tournament_id}")

    case Frobots.Events.list_match_by(
           [tournament_id: tournament_id, tournament_match_type: tournament_match_type],
           [:battlelog]
         ) do
      [] ->
        :ok

      matches ->
        Enum.each(matches, fn match ->
          frobots = match.frobots
          winners = match.battlelog.winners
          update_score(frobots, match, winners)
        end)
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(
        :knockout_matches,
        %{tournament_id: tournament_id, admin_user: admin_user, match_index: match_index} = state
      ) do
    Logger.info("Create Knockout Matches for Tournament #{tournament_id}")
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    participants = length(tournament.tournament_players)

    match_index =
      cond do
        participants > 16 ->
          ## Update Pool Matches Score after 5 Hours
          start_after = 5 * 60 * 60 * 1000
          Process.send_after(self(), {:update_score, :knockout}, start_after)

          start_after = 6 * 60 * 60 * 1000
          Process.send_after(self(), :qualifier_matches, start_after)
          tournament_matches(:knockout, tournament, admin_user, match_index)

        participants > 8 ->
          ## Update Qualifier Matches Score after 5 Hours
          start_after = 5 * 60 * 60 * 1000
          Process.send_after(self(), {:update_score, :qualifier}, start_after)

          start_after = 6 * 60 * 60 * 1000
          Process.send_after(self(), :semifinal_matches, start_after)
          tournament_matches(:qualifier, tournament, admin_user, match_index)

        participants > 4 ->
          ## Update Qualifier Matches Score after 5 Hours
          start_after = 5 * 60 * 60 * 1000
          Process.send_after(self(), {:update_score, :semifinal}, start_after)

          start_after = 6 * 60 * 60 * 1000
          Process.send_after(self(), :final_match, start_after)
          tournament_matches(:semifinal, tournament, admin_user, match_index)

        participants > 2 ->
          # start_after = 6 * 60 * 60 * 1000
          # Process.send_after(self(), :elimination_matches, start_after)
          start_after = 3 * 60 * 60 * 1000
          Process.send_after(self(), {:update_score, :final}, start_after)

          tournament_matches(:final, tournament, admin_user, match_index)
      end

    {:noreply, state |> Map.put(:match_index, match_index)}
  end

  @impl true
  def handle_info(
        :qualifier_matches,
        %{tournament_id: tournament_id, admin_user: admin_user, match_index: match_index} = state
      ) do
    Logger.info("Create Qualifier Matches for Tournament #{tournament_id}")

    start_after = 5 * 60 * 60 * 1000
    Process.send_after(self(), {:update_score, :qualifier}, start_after)

    start_after = 6 * 60 * 60 * 1000
    Process.send_after(self(), :semifinal_matches, start_after)
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    match_index = tournament_matches(:qualifier, tournament, admin_user, match_index)

    {:noreply, state |> Map.put(:match_index, match_index)}
  end

  @impl true
  def handle_info(
        :semifinal_matches,
        %{tournament_id: tournament_id, admin_user: admin_user, match_index: match_index} = state
      ) do
    Logger.info("Create Semi Final Matches for Tournament #{tournament_id}")

    start_after = 5 * 60 * 60 * 1000
    Process.send_after(self(), {:update_score, :semifinal}, start_after)

    start_after = 6 * 60 * 60 * 1000
    Process.send_after(self(), :final_match, start_after)
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    match_index = tournament_matches(:semifinal, tournament, admin_user, match_index)

    {:noreply, state |> Map.put(:match_index, match_index)}
  end

  @impl true
  def handle_info(
        :final_match,
        %{tournament_id: tournament_id, admin_user: admin_user, match_index: match_index} = state
      ) do
    Logger.info("Create Final Match for Tournament #{tournament_id}")

    start_after = 5 * 60 * 60 * 1000
    Process.send_after(self(), {:update_score, :final}, start_after)

    start_after = 6 * 60 * 60 * 1000
    Process.send_after(self(), :update_tournament, start_after)
    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    match_index = tournament_matches(:semifinal, tournament, admin_user, match_index)

    {:noreply, state |> Map.put(:match_index, match_index)}
  end

  @impl true
  def handle_info(:update_tournament, state) do
    Logger.info("Update Tournament")
    {:noreply, state}
  end

  defp tournament_matches(:knockout, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by(
        [tournament_id: tournament.id],
        [desc: :score],
        16
      )

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn [f1, f2], match_index ->
      params = create_match_params("knockout", 0, match_index, tournament, admin_user.id, f1, f2)

      {:ok, _match} = Frobots.Events.create_match(params)
      match_index + 1
    end)

    :ok
  end

  defp tournament_matches(:qualifier, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by([tournament_id: tournament.id], [desc: :score], 8)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn [f1, f2], match_index ->
      params = create_match_params("qualifier", 0, match_index, tournament, admin_user.id, f1, f2)

      {:ok, _match} = Frobots.Events.create_match(params)
      match_index + 1
    end)
  end

  defp tournament_matches(:semifinal, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by([tournament_id: tournament.id], [desc: :score], 4)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn [f1, f2], match_index ->
      params = create_match_params("semifinal", 0, match_index, tournament, admin_user.id, f1, f2)

      {:ok, _match} = Frobots.Events.create_match(params)
      match_index + 1
    end)
  end

  defp tournament_matches(:final, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by([tournament_id: tournament.id], [desc: :score], 2)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn [f1, f2], match_index ->
      params = create_match_params("final", 0, match_index, tournament, admin_user.id, f1, f2)

      {:ok, _match} = Frobots.Events.create_match(params)
      match_index + 1
    end)
  end

  defp update_score(frobots, match, winners) do
    Enum.each(frobots, fn frobot ->
      score = get_score(frobot, winners)

      tp =
        Frobots.Events.get_tournament_players_by(
          tournament_id: match.tournament_id,
          frobot_id: frobot.id
        )

      Frobots.Events.update_tournament_players(tp, %{score: tp.score + score})
    end)
  end

  defp get_score(frobot, winners) do
    cond do
      ## winnner
      frobot.id in winners and length(winners) == 1 -> 5
      ## loser
      frobot.id not in winners -> 1
      ## tie
      true -> 3
    end
  end

  # @impl true
  # def handle_info(:create_matches, %{tournament_id: tournament_id} = state) do
  #   Logger.info("create matches for tournament #{tournament_id}")
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
  def pairing(frobot_ids) do
    # Get the tournament match type from tournament_players ordered by rank
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
      "min_player_frobot" => 1,
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
      ],
      "frobot_ids" => [f1, f2],
      "match_template" => %{
        "entry_fee" => 0,
        "commission_rate" => 0,
        "match_type" => "individual",
        "payout_map" => [100],
        "max_frobots" => 2,
        "min_frobots" => 1
      }
    }
  end

  def pool_mapper(participants, participant_per_pool \\ 5) do
    number_of_fully_filled_pools = div(participants, participant_per_pool)
    _reminder = rem(participants, participant_per_pool)

    {number_of_fully_filled_pools, 0, participant_per_pool}
  end
end
