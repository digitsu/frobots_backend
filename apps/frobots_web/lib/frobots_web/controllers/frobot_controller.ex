defmodule FrobotsWeb.FrobotController do
  use FrobotsWeb, :controller

  alias Frobots.Assets
  alias Frobots.Assets.Frobot

  def index(conn, _params) do
    frobots = Assets.list_frobots()
    render(conn, "index.html", frobots: frobots)
  end

  def new(conn, _params) do
    changeset = Assets.change_frobot(%Frobot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"frobot" => frobot_params}) do
    case Assets.create_frobot(frobot_params) do
      {:ok, frobot} ->
        conn
        |> put_flash(:info, "Frobot created successfully.")
        |> redirect(to: Routes.frobot_path(conn, :show, frobot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    frobot = Assets.get_frobot!(id)
    render(conn, "show.html", frobot: frobot)
  end

  def edit(conn, %{"id" => id}) do
    frobot = Assets.get_frobot!(id)
    changeset = Assets.change_frobot(frobot)
    render(conn, "edit.html", frobot: frobot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "frobot" => frobot_params}) do
    frobot = Assets.get_frobot!(id)

    case Assets.update_frobot(frobot, frobot_params) do
      {:ok, frobot} ->
        conn
        |> put_flash(:info, "Frobot updated successfully.")
        |> redirect(to: Routes.frobot_path(conn, :show, frobot))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", frobot: frobot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    frobot = Assets.get_frobot!(id)
    {:ok, _frobot} = Assets.delete_frobot(frobot)

    conn
    |> put_flash(:info, "Frobot deleted successfully.")
    |> redirect(to: Routes.frobot_path(conn, :index))
  end
end
