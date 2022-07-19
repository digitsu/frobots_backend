defmodule FrobotsWeb.Api.Login do
  @moduledoc """
  A module plug tha werifies the bearer token in the request headers and assigns `:current_user`. The authorization header value may look like `Bearer xxxxxx`.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_userpass()
    |> login_with_userpass()
    |> case do
      # we can safely assume that if token is valid, it must have been created by a valid user in the db.
      {:ok, user} -> assign(conn, :current_user, user)
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  def login_with_userpass(basic_auth_token) do
    if basic_auth_token do
      with {:ok, admin_pass} <- Base.decode64(basic_auth_token),
           %{"username" => username, "pass" => pass} <-
             Regex.named_captures(~r/(?<username>.+):(?<pass>.+)/, admin_pass) do
        Frobots.Accounts.authenticate_by_username_and_pass(username, pass)
      end
    end
  end

  @spec get_userpass(Plug.Conn.t()) :: nil | binary
  def get_userpass(conn) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> token] -> token
      _ -> nil
    end
  end
end
