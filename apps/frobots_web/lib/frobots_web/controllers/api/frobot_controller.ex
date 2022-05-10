defmodule FrobotsWeb.Api.FrobotController do
  use FrobotsWeb, :controller

  alias Frobots.Assets
  alias Frobots.Assets.Frobot

  action_fallback FrobotsWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    frobots = Assets.list_user_frobots(current_user)
    render(conn, "index.json", frobots: frobots)
  end

  def create(conn, %{"frobot" => frobot_params}, current_user) do
    with {:ok, %Frobot{} = frobot} <- Assets.create_frobot(current_user, frobot_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_frobot_path(conn, :show, frobot))
      |> render("show.json", frobot: frobot)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)
    render(conn, "show.json", frobot: frobot)
  end

  def update(conn, %{"id" => id, "frobot" => frobot_params}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)

    with {:ok, %Frobot{} = frobot} <- Assets.update_frobot(frobot, frobot_params) do
      render(conn, "show.json", frobot: frobot)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    frobot = Assets.get_user_frobot!(current_user, id)

    with {:ok, %Frobot{}} <- Assets.delete_frobot(frobot) do
      send_resp(conn, :no_content, "")
    end
  end

  def templates(conn, _params, _current_user) do
    frobots = Assets.list_template_frobots()
    render(conn, "index.json", frobots: frobots)
  end
end
