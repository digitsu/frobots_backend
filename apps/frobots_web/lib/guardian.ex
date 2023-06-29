defmodule FrobotsWeb.Guardian do
  @moduledoc """
  This module is responsible for handling authentication and authorization
  """
  use Guardian, otp_app: :frobots

  alias Frobots.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
