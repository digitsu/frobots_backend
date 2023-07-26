defmodule FrobotsWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :frobots_web,
    pubsub_server: Frobots.PubSub

  @topic "frobots_presence"

  def track(socket) do
    # Subscribe to the topic
    FrobotsWeb.Endpoint.subscribe(topic())

    # Track changes to the topic
    FrobotsWeb.Presence.track(
      self(),
      topic(),
      socket.id,
      %{}
    )
  end

  def topic(), do: @topic
end
