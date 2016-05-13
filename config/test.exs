use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pannic_server, PannicServer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pannic_server, PannicServer.Repo,
  adapter: Mongo.Ecto,
  database: "pannic_server_test",
  pool_size: 1

config :pannic_server, mailer_api: Util.Mailer.InMemory
