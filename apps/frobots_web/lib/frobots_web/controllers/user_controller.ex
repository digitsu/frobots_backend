defmodule FrobotsWeb.UserController do
  use FrobotsWeb, :controller

  alias Frobots.Accounts
  alias Frobots.Accounts.User
  plug :authenticate when action in [:index, :show, :update, :delete]

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    users = Accounts.list_users()

    displayable_users =
      Enum.filter(users, fn user ->
        Accounts.user_is_admin?(current_user) or user.username == current_user.username
      end)

    render(conn, "index.html", users: displayable_users)
  end

  def new(conn, _params, _current_user) do
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, _current_user) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> FrobotsWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created successfully.")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    if allowed_access_to(current_user, user) do
      token = FrobotsWeb.Api.Auth.generate_token(user.username)
      render(conn, "show.html", user: user, token: token)
    else
      conn |> redirect(to: Routes.user_path(conn, :index)) |> halt()
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    if allowed_access_to(current_user, user) do
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      conn |> redirect(to: Routes.user_path(conn, :index)) |> halt()
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, _current_user) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    if allowed_access_to(current_user, user) do
      {:ok, _user} = Accounts.delete_user(user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :index))
    else
      conn |> redirect(to: Routes.user_path(conn, :index)) |> halt()
    end
  end

  # the authenticate controller PLUG
  defp authenticate(conn, opts) do
    authenticate_user(conn, opts)
  end

  defp allowed_access_to(current_user, user) do
    current_user &&
      (user.username == current_user.username or Accounts.user_is_admin?(current_user))
  end
end
