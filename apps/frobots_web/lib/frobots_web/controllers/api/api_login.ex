defmodule FrobotsWeb.Api.Login do
  @moduledoc """
  A module plug tha werifies the bearer token in the request headers and assigns `:current_user`. The authorization header value may look like `Bearer xxxxxx`.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user =
      conn
      |> get_userpass()
      |> login_with_userpass()

    assign(conn, :current_user, user)
  end

  def login_with_userpass(basic_auth_token) do
    if basic_auth_token do
      with {:ok, admin_pass} <- Base.decode64(basic_auth_token),
           %{"username" => username, "pass" => pass} <-
             Regex.named_captures(~r/(?<username>.+):(?<pass>.+)/, admin_pass) do
        # change usernamet to email
        user = Frobots.Accounts.get_user_by(email: username)
        Frobots.Accounts.get_user_by_email_and_password(user.email, pass)
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
