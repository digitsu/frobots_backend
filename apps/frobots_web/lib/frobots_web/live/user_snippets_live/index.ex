defmodule FrobotsWeb.UserSnippetsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.Assets

  @impl Phoenix.LiveView
  def mount(params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    
    end
  end

  # add additional handle param events as needed to handle button clicks etc

end
