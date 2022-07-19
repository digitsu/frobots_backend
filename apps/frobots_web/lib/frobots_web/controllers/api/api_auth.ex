defmodule FrobotsWeb.Api.Auth do
  @moduledoc """
  A module plug tha werifies the bearer token in the request headers and assigns `:current_user`. The authorization header value may look like `Bearer xxxxxx`.
  """

  import Plug.Conn
  import Phoenix.Controller
  alias Frobots.Accounts

  @doc """

    A function plug that ensures that `:current_user` value is present.

    ## Examples

      # in a router pipeline
      pipe_through [:api, :authenticate_api_user]

      # in a controller
      plug :authenticate_api_user when action in [:index, :create]

  """
  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> verify_token()
    |> case do
      # we can safely assume that if token is valid, it must have been created by a valid user in the db.
      {:ok, user_id} when is_integer(user_id) -> assign(conn, :current_user, Accounts.get_user_by(id: user_id))
      {:ok, username} when is_binary(username) -> assign(conn, :current_user, Accounts.get_user_by(username: username))
      # or{:error, :invalid}
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  def local_endpoint?() do
    # determine if we are running a local backend in which case we should allow API access that isn't the frontend server
    FrobotsWeb.Endpoint.host() == "localhost"
  end

  def authenticate_api_admin_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user, nil) |> Accounts.user_is_admin?() do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(FrobotsWeb.ErrorView)
      |> render(:"401")
      # Stop any downstream transformations.
      |> halt()
    end
  end

  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user, nil) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(FrobotsWeb.ErrorView)
      |> render(:"401")
      # Stop any downstream transformations.
      |> halt()
    end
  end

  @doc """
    Generate a new token for a user id.

    ## Examples

      iex> FrobotsWeb.API.Auth.generate_token(123)
      "xxxxxxxxxxxxx"

  """

  def generate_token(user_id) do
    Phoenix.Token.sign(
      FrobotsWeb.Endpoint,
      inspect(__MODULE__),
      user_id
    )
  end

  @doc """
  Verify a user token.

  ## Examples

    iex> FrobotsWeb.API.Auth.verify_token("good-token")
    {:ok, 1}

    iex> FrobotsWeb.API.Auth.verify_token("bad-token")
    {:error, :invalid}

    iex> FrobotsWeb.API.Auth.verify_token("old-token")
    {:error, :expired}

    iex> FrobotsWeb.API.Auth.verify_token(nil)
    {:error, :missing}
  """

  @spec verify_token(nil | binary) :: {:error, :expired | :invalid | :missing} | {:ok, any}
  def verify_token(token) do
    one_month = 30 * 24 * 60 * 60

    Phoenix.Token.verify(
      FrobotsWeb.Endpoint,
      inspect(__MODULE__),
      token,
      max_age: 2 * one_month
    )
  end

  @spec get_token(Plug.Conn.t()) :: nil | binary
  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
