defmodule FrobotsWeb.PageController do
  use FrobotsWeb, :controller

  def index(conn, _params) do
    conn
    #|> put_root_layout("app.html")
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render(:index)
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
