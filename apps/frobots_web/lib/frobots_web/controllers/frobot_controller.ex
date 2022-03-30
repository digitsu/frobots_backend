defmodule FrobotsWeb.FrobotController do
  use FrobotsWeb, :controller

  alias Frobots.Assets
  alias Frobots.Assets.Frobot

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    frobots = Assets.list_user_frobots(current_user)
    render(conn, "index.html", frobots: frobots)
  end

  def new(conn, _params, _current_user) do
    changeset = Assets.change_frobot(%Frobot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"frobot" => frobot_params}, current_user) do
    case Assets.create_frobot(current_user, frobot_params) do
      {:ok, frobot} ->
        conn
        |> put_flash(:info, "Frobot created successfully.")
        |> redirect(to: Routes.frobot_path(conn, :show, frobot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)
    render(conn, "show.html", frobot: frobot)
  end

  def edit(conn, %{"id" => id}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)
    changeset = Assets.change_frobot(frobot)
    render(conn, "edit.html", frobot: frobot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "frobot" => frobot_params}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)

    case Assets.update_frobot(frobot, frobot_params) do
      {:ok, frobot} ->
        conn
        |> put_flash(:info, "Frobot updated successfully.")
        |> redirect(to: Routes.frobot_path(conn, :show, frobot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", frobot: frobot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)
    {:ok, _frobot} = Assets.delete_frobot(frobot)

    conn
    |> put_flash(:info, "Frobot deleted successfully.")
    |> redirect(to: Routes.frobot_path(conn, :index))
  end
end
