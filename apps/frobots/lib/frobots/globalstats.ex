defmodule Frobots.GlobalStats do
  @moduledoc """
  The GlobalStats context.
  """
  @derive {Jason.Encoder,
           only: [
             :matches_played,
             :upcoming_matches,
             :completed_matches,
             :current_matches,
             :players_online,
             :players_registered
           ]}
  defstruct matches_played: 0,
            upcoming_matches: 0,
            completed_matches: 0,
            current_matches: 0,
            players_online: 0,
            players_registered: 0

  alias Frobots.Leaderboard
  alias Frobots.{Events, Assets, Accounts}

  @doc ~S"""
  fetch current user global stats details.

  ## Example
      #iex> get_global_stats(%User{})
      #%Frobots.GlobalStats{
      # matches_played: 12,
      # upcoming_matches: 62,
      # completed_matches: 45,
      # current_matches: 16,
      # players_online: 23,
      # players_registered: 30
      #}
  """
  def get_global_stats(current_user, players_online) do
    user_frobots = Assets.get_user_frobots(current_user.id)
    players_registered = Accounts.count_users()

    %Frobots.GlobalStats{
      matches_played: Leaderboard.get_match_participation_count(user_frobots),
      upcoming_matches: Events.count_matches_by_status(:pending),
      completed_matches: Events.count_matches_by_status(:done),
      current_matches: Events.count_matches_by_status(:running),
      players_online: players_online,
      players_registered: players_registered
    }
  end
end
