defmodule FrobotsWeb.Router do
  use FrobotsWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrobotsWeb.LayoutView, :root}
    # include this if you use session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FrobotsWeb.Plugs.Locale, "en"
    plug FrobotsWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug FrobotsWeb.Api.Auth
  end

  pipeline :api_login do
    plug :accepts, ["json"]
    plug FrobotsWeb.Api.Login
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  scope "/", FrobotsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/home", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", FrobotsWeb do
    pipe_through [:browser, :authenticate_user]
    resources "/frobots", FrobotController
  end

  scope "/api/v1", FrobotsWeb, as: :api do
    pipe_through [:api, :authenticate_api_user]
    get "/frobots/templates", Api.FrobotController, :templates
    resources "/frobots", Api.FrobotController, except: [:new, :edit]
    resources "/users", Api.UserController, except: [:new, :edit]
  end

  scope "/token", FrobotsWeb, as: :api do
    pipe_through [:api_login]
    get "/generate", Api.TokenController, :gen_token
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrobotsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  defp admin_basic_auth(conn, _opts) do
    admin_user = Keyword.fetch!(Application.get_env(:frobots_web, :basic_auth), :username)
    admin_pass = Keyword.fetch!(Application.get_env(:frobots_web, :basic_auth), :password)
    Plug.BasicAuth.basic_auth(conn, username: admin_user, password: admin_pass)
  end

  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admins_only]

      live_dashboard "/dashboard", metrics: FrobotsWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
