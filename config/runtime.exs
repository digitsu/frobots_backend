import Config

s3_store_url =
  System.get_env("S3_URL") ||
    raise """
    environment variable S3_URL is missing.
    Did you forget to source env vars?
    """

s3_store_bucket =
  System.get_env("S3_BUCKET") ||
    raise """
    environment variable S3_BUCKET is missing.
    Did you forget to source env vars?
    """

config :ex_aws, :s3,
  scheme: "https://",
  host: s3_store_url,
  region: "US",
  bucket: s3_store_bucket

config :ex_aws,
  debug_requests: true,
  access_key_id: [{:system, "S3_ACCESS_KEY"}, :instance_role],
  secret_access_key: [{:system, "S3_SECRET_KEY"}, :instance_role],
  region: "US"

config :ex_aws, :s3,
  scheme: "https://",
  host: s3_store_url,
  region: "US",
  bucket: s3_store_bucket

if config_env() == :prod || config_env() == :staging do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :frobots_web, FrobotsWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base

  admin_user =
    System.get_env("ADMIN_USER") ||
      raise """
      environment variable ADMIN_USER is missing.
      Did you forget to source env vars?
      """

  admin_pass =
    System.get_env("ADMIN_PASS") ||
      raise """
      environment variable ADMIN_PASS is missing.
      Did you forget to source env vars?
      """

  # configures the dashboard admin password -- make sure to use SSL when we open up the server to public as inputs are exposed in transit via basic_auth
  config :frobots_web, :basic_auth, username: admin_user, password: admin_pass

  sendgrid_mailinglist_key =
    System.get_env("SENDGRID_API_EXPORT_MAILINGLIST_KEY") ||
      raise """
      environment variable SENDGRID_API_EXPORT_MAILINGLIST_KEY is missing.
      Did you forget to source env vars?
      """

  sendgrid_api_key =
    System.get_env("SENDGRID_API_KEY") ||
      raise """
      environment variable SENDGRID_API_KEY is missing.
      Did you forget to source env vars?
      """

  config :frobots, Frobots.Mailer,
    adapter: Swoosh.Adapters.Sendgrid,
    api_key: sendgrid_api_key,
    domain: "frobots.io"

  config :sendgrid,
    sendgrid_mailinglist_key: sendgrid_mailinglist_key,
    base_url: "https://api.sendgrid.com",
    send_mail: config_env() == :prod

  ghost_api_key =
    System.get_env("GHOST_API_KEY") ||
      raise """
      environment variable GHOST_API_KEY is missing.
      Did you forget to source env vars?
      """

  config :frobots_web,
         :ghost_blog_url,
         "https://ghost.fubars.tech/ghost/api/content/posts/?key=#{ghost_api_key}"

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  config :frobots_web, FrobotsWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :frobots_web, Frobots.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

  database_url =
    System.get_env("DATABASE_URL") ||
      raise("""
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """)

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :frobots, Frobots.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
end
