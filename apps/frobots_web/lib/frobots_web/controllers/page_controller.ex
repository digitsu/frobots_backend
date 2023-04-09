defmodule FrobotsWeb.PageController do
  use FrobotsWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: "/home")
  end

  '''
  hand craft our own responses like this using Plug module directly
  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "")
  end
  '''
end
