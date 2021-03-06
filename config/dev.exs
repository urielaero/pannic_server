use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :pannic_server, PannicServer.Endpoint,
  http: [port: 5000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :pannic_server, PannicServer.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :pannic_server, PannicServer.Repo,
  adapter: Mongo.Ecto,
  database: "pannic_server_dev",
  pool_size: 10

config :pannic_server, mailgun_domain: System.get_env("MAILGUN_DOMAIN"), mailgun_key: System.get_env("MAILGUN_KEY")

config :pannic_server, mailer_api: Util.Mailer
