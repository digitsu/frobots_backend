import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1
config :frobots, cron_interval: 60 * 60

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
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database:
    System.get_env("POSTGRES_DB") || "frobots_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :pbkdf2_elixir, :rounds, 1

config :fubars, registry_name: :test_match_registry

# swoosh stuff -- needed for testing
config :frobots, Frobots.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Hackney

s3_store_secret_key = "ITSBzZHA7GafFBa2s2XHjgCgCd94BEXKBYY8TPq9"
s3_store_access_key = "RO60YNHMCAU9G7VQ0AOE"

# config :frobots_web, :ghost_blog_url, "http://localhost/blog"
s3_store_url = System.get_env("S3_URL") || "ap-south-1.linodeobjects.com"
s3_store_bucket = System.get_env("S3_BUCKET") || "frobots-assets"

config :ex_aws,
  debug_requests: true,
  access_key_id: [s3_store_access_key, :instance_role],
  secret_access_key: [s3_store_access_key, :instance_role],
  region: "US"

config :ex_aws, :s3,
  scheme: "https://",
  host: s3_store_url,
  region: "US",
  bucket: s3_store_bucket
