defmodule FrobotsWeb.Api.UserController do
  use FrobotsWeb, :controller

  alias Frobots.Accounts
  alias Frobots.Accounts.User
  alias FrobotsWeb.Auth

  action_fallback FrobotsWeb.FallbackController

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

    render(conn, "index.json", users: displayable_users)
  end

  def create(conn, %{"user" => user_params}, current_user) do
    if Accounts.user_is_admin?(current_user) do
      with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
    else
      render_unauthorized(conn)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    if Auth.allowed_access_to(current_user, user) do
      render(conn, "show.json", user: user)
    else
      render_unauthorized(conn)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    user = Accounts.get_user!(id)

    if Auth.allowed_access_to(current_user, user) do
      # with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      #   render(conn, "show.json", user: user)
      # end
      updated_user =
        case Map.get(user_params, "password") do
          "" -> Accounts.update_user(user, user_params)
          nil -> Accounts.update_user(user, user_params)
          _ -> Accounts.update_registration(user, user_params)
        end

      case updated_user do
        {:ok, user} ->
          render(conn, "show.json", user: user)

        {:error, %Ecto.Changeset{} = _changeset} ->
          # render(conn, "edit.html", user: user, changeset: changeset)
          conn |> put_status(422) |> json(%{errors: "updated failed"})
      end
    else
      render_unauthorized(conn)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    if Auth.allowed_access_to(current_user, user) do
      with {:ok, %User{}} <- Accounts.delete_user(user) do
        send_resp(conn, :no_content, "")
      end
    else
      render_unauthorized(conn)
    end
  end

  defp render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(FrobotsWeb.ErrorView)
    |> render(:"401")
    |> halt()
  end
end
