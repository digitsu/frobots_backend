import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :frobots_web, FrobotsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IZ7q8fWodvAxqrp1mStkwjFuZBxPsFSexR/Vzty076/G5SxJADSTe1VLc2kB1wX+",
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :frobots, Frobots.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "frobots_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :pbkdf2_elixir, :rounds, 1