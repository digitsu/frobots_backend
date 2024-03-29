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
## in seconds
config :frobots, status_reset_interval: 60
config :frobots, cron_interval: 1
config :frobots, tournament_match_interval: 24 * 60 * 60
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

#  cache_static_manifest: "priv/static/cache_manifest.json"

config :tailwind,
  version: "3.1.6",
  default: [
    args: ~w(
        --config=tailwind.config.js
        --input=css/app.css
        --output=../priv/static/assets/app.css
      ),
    cd: Path.expand("../apps/frobots_web/assets", __DIR__)
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.tsx --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --external:/docs/*),
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

config :frobots, FrobotsWeb.Guardian,
  issuer: "frobots",
  secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
  ttl: {3, :days}

config :frobots, FrobotsWeb.AuthAccessPipeline,
  module: FrobotsWeb.Guardian,
  error_handler: FrobotsWeb.AuthErrorHandler

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

config :logger, :ui_events,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: :evt_type

config :logger, :file_log,
  path: "/tmp/frobotsLog.log",
  level: :info

# import_config "#{Mix.env}.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :evt_type],
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_client,
  socket: [
    url: "ws://localhost:4000/socket/websocket"
  ]

config :frobots_web, env: Mix.env()

config :frobots_web, :beta_email_list, System.get_env("BETA_EMAIL_LIST")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

import_config "appsignal.exs"
