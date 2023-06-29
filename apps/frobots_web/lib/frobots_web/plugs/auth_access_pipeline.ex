defmodule FrobotsWeb.AuthAccessPipeline do
  @moduledoc """
  Auth Access Pipeline
  """
  use Guardian.Plug.Pipeline, otp_app: :frobots

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
