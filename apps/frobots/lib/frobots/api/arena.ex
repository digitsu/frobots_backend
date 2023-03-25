defmodule Frobots.Api.Arena do
  alias Frobots.Events
  # this is the FE api for liveview pages on the Arena

  def create_match(match_details) do
    Events.create_match(match_details)
  end

  def join_match(_user, _match) do
  end
end
