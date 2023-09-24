defmodule FrobotsWeb.Router do
  use FrobotsWeb, :router
  import FrobotsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrobotsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_s3_base_url
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    # guardian functions
    plug FrobotsWeb.AuthAccessPipeline
  end

  pipeline :require_authenticated_api do
    # guardian functions
    plug :accepts, ~w(html json)
    plug FrobotsWeb.Api.Auth
  end

  pipeline :api_login do
    plug :accepts, ["json"]
    plug FrobotsWeb.Api.Login
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  # gen auth will provide authentication services
  scope "/manage", FrobotsWeb do
    pipe_through [:browser, :require_authenticated_user]
    resources "/frobots", FrobotController
  end

  scope "/api/v1", FrobotsWeb, as: :api do
    pipe_through [:require_authenticated_api]
    get "/frobots/templates", Api.FrobotController, :templates
    resources "/frobots", Api.FrobotController, except: [:new, :edit]
  end

  scope "/token", FrobotsWeb, as: :api do
    pipe_through [:api_login]
    get "/generate", Api.TokenController, :gen_token
  end

  # unprotected route to get leaderboard entries
  scope "/api/v1", FrobotsWeb, as: :api do
    pipe_through [:api]
    get "/leaderboard", Api.LeaderboardController, :index
    post "/users/log_in", Api.UserSessionController, :create
    get "/assets/user_classes", Api.AssetsController, :index
    get "/events/match/:id", Api.EventsController, :start_match
    put "/events/match/:id/start", Api.EventsController, :start_match
    put "/events/match/:id", Api.EventsController, :change
  end

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

  ## Authenticed routes

  scope "/", FrobotsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]
    # live routes
    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", FrobotsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/home", HomeLive.Index, :index
    live "/teams", TeamLive.Index, :index
    live "/matches", MatchLive.Index, :index
    live "/docs", DocsLive.Index, :index
    live "/blogs", NewsAndUpdatesLive.Index, :index
    live "/profile", UserProfileLive.Index, :index
    live "/player", PlayerProfileLive.Index, :index

    live "/admin", AdminLive.Index, :index

    # arena
    live "/arena", ArenaLive.Index, :index
    live "/arena/:match_status/matches", ArenaMatchesLive.Index, :index
    live "/arena/create", ArenaCreateMatchLive.Index, :index
    live "/arena/:match_id", ArenaLobbyLive.Index, :index
    live "/arena/:match_id/results", MatchResultsLive.Index, :index
    live "/arena/:match_id/simulation", ArenaMatchSimulationLive.Index, :index
    live "/arena/:match_id/replay", ArenaMatchReplayLive.Index, :index

    # manage users
    live "/users", UsersLive.Index, :index
    live "/users/new", UsersLive.Index, :new
    live "/snippets", UserSnippetsLive.Index, :index

    # garage
    live "/garage", GarageFrobotsListLive.Index, :index
    live "/garage/create", GarageFrobotCreateLive.Index, :index
    live "/garage/frobot", GarageFrobotsDetailsLive.Index, :index
    live "/garage/frobot/braincode", FrobotBraincodeLive.Index, :index
    live "/garage/frobot/equipment_bay", FrobotEquipmentBayLive.Index, :index
    live "/garage/frobot/edit", FrobotDetailsEditLive.Index, :index

    # tournaments
    live "/tournaments", TournamentsLive.Index, :index
    live "/tournaments/create", TournamentCreateLive.Index, :index
    live "/tournaments/:tournament_id", TournamentDetailsLive.Index, :index

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", FrobotsWeb do
    pipe_through [:browser]
    get "/", PageController, :index
    delete "/users/log_out", UserSessionController, :delete
    get "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
