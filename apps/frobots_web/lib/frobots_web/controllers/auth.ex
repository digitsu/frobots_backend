defmodule FrobotsWeb.Auth do
  import Plug.Conn

  import Phoenix.Controller
  alias Frobots.Accounts
  alias FrobotsWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      # if we see we already have a current user, then just return the conn, no matter what the current user is. (makes tests vastly simpler)
      conn.assigns[:current_user] ->
        conn

      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)

      true ->
        # this is handy for auth tests, which need a nil set current_user in the connection
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # protect against session fixation attacks.
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  # this fn is not unique to the non-api authorization. its a general fn used by all authorization pipelines.
  # this ensures that the user doing the editing is doing it on themselves, or is an admin
  def allowed_access_to(current_user, user) do
    current_user &&
      (user.username == current_user.username or Accounts.user_is_admin?(current_user))
  end
end
