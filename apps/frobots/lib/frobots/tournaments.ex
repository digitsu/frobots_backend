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

    cond do
      tournament.status == :open ->
        ## start after 15 seconds of scheduled time
        start_after = (tournament.starts_at - System.os_time(:second) + 15) * 1000

        start_after =
          if start_after < 0 do
            1_000
          else
            start_after
          end

        Process.send_after(self(), :pool_matches, start_after)

      tournament.status == :inprogress ->
        maybe_start_next_round(tournament.id)

      true ->
        :ok
    end

    match_index = get_match_index(tournament_id)
    {:ok, %{tournament_id: tournament_id, admin_user: admin_user, match_index: match_index}}
  end

  @impl true
  def handle_info(:pool_matches, %{tournament_id: tournament_id, admin_user: admin_user} = state) do
    Logger.info("Create Pools for Tournament #{tournament_id}")

    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    {:ok, _} = Frobots.Events.update_tournament(tournament, %{status: :inprogress})

    participants = length(tournament.tournament_players)

    {number_of_fully_filled_pools, number_of_partially_filled_pools, participant_per_pool} =
      pool_mapper(participants)

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
      Enum.reduce(fully_filled_pools, 0, fn pool_participants, index ->
        Enum.each(pool_participants, fn pool_participant ->
          {:ok, _} =
            Frobots.Events.update_tournament_players(pool_participant, %{
              match_sub_type: index + 1
            })
        end)

        index + 1
      end)

    _total_index =
      Enum.reduce(partially_filled_pools, total_index, fn pool_participants, index ->
        Enum.each(pool_participants, fn pool_participant ->
          {:ok, _} =
            Frobots.Events.update_tournament_players(pool_participant, %{
              tournament_match_sub_type: index + 1
            })
        end)

        index + 1
      end)

    {pool_index, match_index} =
      Enum.reduce(fully_filled_pools, {0, 0}, fn pool_participants, {pool_index, match_index} ->
        match_index =
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
                pool_index + 1,
                match_index + 1,
                tournament,
                admin_user.id,
                f1,
                f2
              )

            {:ok, _match} = Frobots.Events.create_match(params)
            match_index + 1
          end)

        {pool_index + 1, match_index + 1}
      end)

    {_, match_index} =
      Enum.reduce(partially_filled_pools, {pool_index, match_index}, fn pool_participants,
                                                                        {pool_index, match_index} ->
        match_index =
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
                pool_index + 1,
                match_index + 1,
                tournament,
                admin_user.id,
                f1,
                f2
              )

            {:ok, _match} = Frobots.Events.create_match(params)
            match_index + 1
          end)

        {pool_index + 1, match_index + 1}
      end)

    ## 3 mins for the match + 10 mins running time of match + 2 mins buffer
    # start_after = 15 * 60 * 1000
    # Process.send_after(self(), :knockout_matches, start_after)

    {:noreply,
     state |> Map.put(:match_index, match_index) |> Map.put(:tournament_id, tournament.id)}
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
          tournament_matches(:knockout, tournament, admin_user, match_index)

        # start_after = 2 * 60 * 60 * 1000
        # Process.send_after(self(), :qualifier_matches, start_after)

        participants > 8 ->
          tournament_matches(:qualifier, tournament, admin_user, match_index)

        # start_after = 2 * 60 * 60 * 1000
        # Process.send_after(self(), :semifinal_matches, start_after)

        participants > 4 ->
          tournament_matches(:semifinal, tournament, admin_user, match_index)

        # start_after = 2 * 60 * 60 * 1000
        # Process.send_after(self(), :final_match, start_after)

        participants > 2 ->
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

    # start_after = 2 * 60 * 60 * 1000
    # Process.send_after(self(), :semifinal_matches, start_after)

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

    # 6 * 60 * 60 * 1000
    # start_after = 2 * 60 * 60 * 1000
    # Process.send_after(self(), :final_match, start_after)

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

    # start_after = 30 * 60 * 1000
    # Process.send_after(self(), :update_tournament, start_after)

    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    match_index = tournament_matches(:semifinal, tournament, admin_user, match_index)

    {:noreply, state |> Map.put(:match_index, match_index)}
  end

  @impl true
  def handle_info(:update_tournament, %{tournament_id: tournament_id} = state) do
    Logger.info("Update Tournament .........")

    {:ok, tournament} =
      Frobots.Events.get_tournament_by([id: tournament_id], [:tournament_players])

    Frobots.Events.update_tournament(tournament, %{
      status: :completed,
      ended_at: System.os_time(:second)
    })

    {:noreply, state}
  end

  defp tournament_matches(:knockout, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by(
        [tournament_id: tournament.id],
        [desc: :score, asc: :inserted_at],
        16
      )

    Enum.each(tp, fn p ->
      Frobots.Events.update_tournament_players(p, %{tournament_match_type: :knockout})
    end)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn frobots, match_index ->
      {f1, f2} =
        cond do
          is_list(frobots) ->
            [f1, f2] = frobots
            {f1, f2}

          is_tuple(frobots) ->
            frobots

          true ->
            {nil, nil}
        end

      if is_nil(f1) or is_nil(f2) do
        match_index
      else
        params =
          create_match_params("knockout", 0, match_index, tournament, admin_user.id, f1, f2)

        {:ok, _match} = Frobots.Events.create_match(params)
        match_index + 1
      end
    end)
  end

  defp tournament_matches(:qualifier, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by(
        [tournament_id: tournament.id],
        [desc: :score, asc: :inserted_at],
        8
      )

    Enum.each(tp, fn p ->
      Frobots.Events.update_tournament_players(p, %{tournament_match_type: :qualifier})
    end)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn frobots, match_index ->
      {f1, f2} =
        cond do
          is_list(frobots) ->
            [f1, f2] = frobots
            {f1, f2}

          is_tuple(frobots) ->
            frobots

          true ->
            {nil, nil}
        end

      if is_nil(f1) or is_nil(f2) do
        match_index
      else
        params =
          create_match_params("qualifier", 0, match_index, tournament, admin_user.id, f1, f2)

        {:ok, _match} = Frobots.Events.create_match(params)
        match_index + 1
      end
    end)
  end

  defp tournament_matches(:semifinal, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by(
        [tournament_id: tournament.id],
        [desc: :score, asc: :inserted_at],
        4
      )

    Enum.each(tp, fn p ->
      Frobots.Events.update_tournament_players(p, %{tournament_match_type: :semifinal})
    end)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn frobots, match_index ->
      {f1, f2} =
        cond do
          is_list(frobots) ->
            [f1, f2] = frobots
            {f1, f2}

          is_tuple(frobots) ->
            frobots

          true ->
            {nil, nil}
        end

      if is_nil(f1) or is_nil(f2) do
        match_index
      else
        params =
          create_match_params("semifinal", 0, match_index, tournament, admin_user.id, f1, f2)

        {:ok, _match} = Frobots.Events.create_match(params)
        match_index + 1
      end
    end)
  end

  defp tournament_matches(:final, tournament, admin_user, match_index) do
    tp =
      Frobots.Events.list_tournament_players_by(
        [tournament_id: tournament.id],
        [desc: :score, asc: :inserted_at],
        2
      )

    Enum.each(tp, fn p ->
      Frobots.Events.update_tournament_players(p, %{tournament_match_type: :final})
    end)

    frobots_ids = Enum.map(tp, fn tp -> tp.frobot_id end)

    pairing(frobots_ids)
    |> Enum.reduce(match_index, fn frobots, match_index ->
      {f1, f2} =
        cond do
          is_list(frobots) ->
            [f1, f2] = frobots
            {f1, f2}

          is_tuple(frobots) ->
            frobots

          true ->
            {nil, nil}
        end

      if is_nil(f1) or is_nil(f2) do
        match_index
      else
        params = create_match_params("final", 0, match_index, tournament, admin_user.id, f1, f2)

        {:ok, _match} = Frobots.Events.create_match(params)
        match_index + 1
      end
    end)
  end

  # Each FROBOT plays each other in scheduled matches in each pool.
  # Wins score a 5.
  # Ties (timeout) score a 3
  # Losses score a 1
  def pairing(frobot_ids) do
    # Get the tournament match type from tournament_players ordered by rank
    max_range = div(length(frobot_ids), 2) - 1

    if max_range < 0 do
      []
    else
      pairing =
        Enum.reduce(0..max_range, [], fn index, acc ->
          acc ++
            [{Enum.at(frobot_ids, index), Enum.at(frobot_ids, length(frobot_ids) - 1 - index)}]
        end)

      ## Logic for ordered pairing
      max_range = div(length(pairing), 2) - 1

      _ordered_pairing =
        Enum.reduce(0..max_range, [], fn index, acc ->
          acc ++ [Enum.at(pairing, index), Enum.at(pairing, length(pairing) - 1 - index)]
        end)
    end
  end

  defp create_match_params(match_type, match_sub_type, match_id, tournament, user_id, f1, f2) do
    tournament_match_interval = Application.get_env(:frobots, :tournament_match_interval)

    %{
      "user_id" => user_id,
      "title" => "Match of #{tournament.name}",
      "description" => "Match of #{tournament.description}",
      ## Start After 3 mins
      "match_time" =>
        DateTime.utc_now()
        |> DateTime.add(tournament_match_interval, :second)
        |> DateTime.to_string(),
      "type" => "real",
      "tournament_match_type" => match_type,
      "tournament_match_sub_type" => match_sub_type,
      "tournament_match_id" => match_id,
      "tournament_id" => tournament.id,
      # 15 mins
      "timer" => 900,
      "arena_id" => tournament.arena_id,
      "min_player_frobot" => 2,
      "max_player_frobot" => 2,
      "slots" => [
        %{
          "frobot_id" => f1,
          "status" => "ready",
          "slot_type" => "host"
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
        "min_frobots" => 2
      }
    }
  end

  def pool_mapper(participants, participant_per_pool \\ 5) do
    x = trunc(:math.ceil(participants / participant_per_pool))
    reminder = rem(participants, x)
    participant_per_pool = div(participants, x)

    if reminder > 0 do
      {reminder, x - reminder, participant_per_pool + 1}
    else
      {x, 0, participant_per_pool}
    end
  end

  defp get_match_type(tournament_id) do
    Frobots.Api.list_match_by([tournament: tournament_id], [], desc: :tournament_match_id)
    |> List.first()
    |> case do
      nil -> nil
      match -> match.tournament_match_type
    end
  end

  defp get_match_index(tournament_id) do
    case Frobots.Api.list_match_by([tournament_id: tournament_id], [], desc: :tournament_match_id)
         |> List.first() do
      nil ->
        1

      match ->
        match.tournament_match_id + 1
    end
  end

  defp maybe_start_next_round(tournament_id) do
    ## In 30 seconds
    start_after = 30 * 1000

    if Frobots.Api.list_match_by(tournament_id: tournament_id)
       |> Enum.all?(fn m -> m.status == :done end) do
      ## Place Next Matches
      case get_match_type(tournament_id) do
        nil ->
          Process.send_after(self(), :pool_matches, start_after)

        :pool ->
          Process.send_after(self(), :knockout_matches, start_after)

        :knockout ->
          Process.send_after(self(), :qualifier_matches, start_after)

        :qualifier ->
          Process.send_after(self(), :semifinal_matches, start_after)

        :semifinal ->
          Process.send_after(self(), :final_match, start_after)

        :final ->
          :ok
      end
    end
  end
end
