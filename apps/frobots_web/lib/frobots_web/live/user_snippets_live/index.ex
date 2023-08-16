defmodule FrobotsWeb.UserSnippetsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.Assets

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    _current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok, socket}
  end
end
