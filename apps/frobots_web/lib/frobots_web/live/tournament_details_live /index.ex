defmodule FrobotsWeb.TournamentDetailsLive.Index do
  use FrobotsWeb, :live_view
  alias Frobots.Api
  alias Frobots.Accounts
  alias Frobots.Assets
  def mount(params, %{"user_id" => id}, socket) do
    current_user = Accounts.get_user!(id)
    tournament_id = params["tournament_id"]
    tournament_details = Api.get_tournament_details_by_id(tournament_id)
    s3_base_url = Api.get_s3_base_url()

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:s3_base_url, s3_base_url)
     |> assign(:tournament_details, tournament_details)}
  end

  def handle_event("react.fetch_tournament_details", _params, socket) do
    user_frobots =
      extract_frobot_details(Assets.get_available_user_frobots(socket.assigns.current_user.id))

    all_user_frobots =
      extract_frobot_details(Assets.list_user_frobots(socket.assigns.current_user))

    case socket.assigns.tournament_details do
      {:ok, tournament} ->
        {:noreply,
         push_event(socket, "react.return_fetch_tournament_details", %{
           "s3_base_url" => socket.assigns.s3_base_url,
           "tournament_details" => %{
             id: tournament.id,
             name: tournament.name,
             starts_at: tournament.starts_at,
             prizes: tournament.prizes,
             commission_percent: tournament.commission_percent,
             arena_fees_percent: tournament.arena_fees_percent,
             arena_id: tournament.arena_id,
             platform_fees: tournament.platform_fees,
             entry_fees: tournament.entry_fees,
             participants: tournament.participants,
             final_ranking: tournament.final_ranking,
             total_quedos: tournament.total_quedos,
             payouts: tournament.payouts,
             status: tournament.status,
             tournament_players: extract_tournamentplayer_details(tournament.tournament_players),
             matches:
               Enum.map(tournament.matches, fn %{
                                                 id: id,
                                                 title: title,
                                                 status: status,
                                                 match_time: match_time,
                                                 slots: slots,
                                                 max_player_frobot: max_player_frobot,
                                                 min_player_frobot: min_player_frobot,
                                                 started_at: started_at,
                                                 timer: timer,
                                                 battlelog: battlelog
                                               } ->
                 %{
                   id: id,
                   title: title,
                   status: status,
                   match_time: match_time,
                   max_player_frobot: max_player_frobot,
                   min_player_frobot: min_player_frobot,
                   slots: extract_slot_details(slots),
                   started_at: started_at,
                   timer: timer,
                   battlelog: extract_battlelog(battlelog)
                 }
               end)
           },
           "user_frobots" => user_frobots,
           "all_user_frobots" => all_user_frobots
         })}
    end
  end

  def handle_event("react.join_tournament", tournament_props, socket) do
    case Api.join_tournament(tournament_props) do
      {:ok, _tournament} ->
        {:noreply, socket |> put_flash(:info, 'Successfully joined the tournament')}

      {:error, errors} ->
        {:noreply, socket |> put_flash(:error, errors)}
    end
  end

  def handle_event("react.unjoin_tournament", tournament_props, socket) do
    case Api.unjoin_tournament(tournament_props) do
      {:ok, _tournament} ->
        {:noreply, socket |> put_flash(:info, 'Successfully removed from the tournament')}

      {:error, errors} ->
        {:noreply, socket |> put_flash(:error, errors)}
    end
  end

  def extract_tournament_details(tournament) do
    Enum.map(
      tournament,
      fn %{
           id: id,
           name: name,
           starts_at: starts_at,
           prizes: prizes,
           commission_percent: commission_percent,
           arena_fees_percent: arena_fees_percent,
           arena_id: arena_id,
           platform_fees: platform_fees,
           entry_fees: entry_fees,
           participants: participants,
           final_ranking: final_ranking,
           total_quedos: total_quedos,
           payouts: payouts,
           status: status
         } ->
        %{
          id: id,
          name: name,
          starts_at: starts_at,
          prizes: prizes,
          commission_percent: commission_percent,
          arena_fees_percent: arena_fees_percent,
          arena_id: arena_id,
          platform_fees: platform_fees,
          entry_fees: entry_fees,
          participants: participants,
          final_ranking: final_ranking,
          total_quedos: total_quedos,
          payouts: payouts,
          status: status
        }
      end
    )
  end

  def extract_frobot_details(frobots) do
    Enum.map(frobots, fn %{
                           id: id,
                           name: name,
                           xp: xp,
                           class: class,
                           brain_code: brain_code,
                           blockly_code: blockly_code,
                           bio: bio,
                           avatar: avatar
                         } ->
      %{
        id: id,
        name: name,
        xp: xp,
        class: class,
        brain_code: brain_code,
        blockly_code: blockly_code,
        bio: bio,
        avatar: avatar
      }
    end)
  end

  def extract_tournamentplayer_details(tournamentplayer) do
    Enum.map(tournamentplayer, fn %{
                                    frobot_id: frobot_id,
                                    frobot: frobot,
                                    id: id,
                                    score: score,
                                    tournament_id: tournament_id,
                                    tournament_match_type: tournament_match_type,
                                    tournament_match_sub_type: tournament_match_sub_type
                                  } ->
      %{
        frobot_id: frobot_id,
        frobot: %{
          id: frobot.id,
          name: frobot.name,
          avatar: frobot.avatar
        },
        stats:
          elem(Api.player_stats(%{"tournament_id" => tournament_id, "frobot_id" => frobot_id}), 1),
        id: id,
        score: score,
        tournament_id: tournament_id,
        tournament_match_type: tournament_match_type,
        tournament_match_sub_type: tournament_match_sub_type
      }
    end)
  end

  defp extract_slot_details(slots) do
    Enum.map(slots, fn %{
                         frobot: frobot,
                         frobot_id: frobot_id,
                         match_id: match_id,
                         slot_type: slot_type,
                         status: status
                       } ->
      %{
        frobot: frobot,
        frobot_id: frobot_id,
        match_id: match_id,
        slot_type: slot_type,
        status: status
      }
    end)
  end

    def extract_battlelog(battlelog), do: if battlelog, do: %{"winners" => battlelog.winners}, else: nil
end
