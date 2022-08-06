# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :frobots, display_process_name: :arena_gui

config :fubars, registry_name: :match_registry

config :frobots_web,
  ecto_repos: [Frobots.Repo],
  generators: [context_app: :frobots]

# Configures the endpoint
config :frobots_web, FrobotsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FrobotsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Frobots.PubSub,
  live_view: [signing_salt: "WEFJDV5M"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/frobots_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure Mix tasks and generators
config :frobots,
  ecto_repos: [Frobots.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :frobots, Frobots.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Hackney

sendgrid_api_key =
  System.get_env("SENDGRID_API_KEY") || "environment variable SENDGRID_API_KEY is missing"

config :frobots, Frobots.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: sendgrid_api_key

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
# Our Logger general configuration
config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :file_log}
  ],
  # this is the most permissive level, no backend can be more inclusive than the level set here.
  level: :debug

#  compile_time_purge_matching: [
#    [level_lower_than: :info]
#  ]

# Our Console Backend-specific configuration
# config :logger, :console,
# format: {Fubars.LogFormatter, :format}
# metadata: [:request_id]

config :logger, :ui_event,
  level: :info,
  metadata: :evt_type

config :logger, :file_log,
  path: "/tmp/frobotsLog.log",
  level: :info

# import_config "#{Mix.env}.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :debug

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
