# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# In dev and prod, convert ms to minutes
config :check_point, 
  convert_minutes: 1000 * 60

config :check_point,
  ecto_repos: [CheckPoint.Repo]

config :check_point, CheckPoint.Repo,
  database: "check_point_repo",
  username: "randy",
  password: "",
  hostname: "localhost"

config :ecto_shorts,
  repo: CheckPoint.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :check_point, CheckPointWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: CheckPointWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CheckPoint.PubSub,
  live_view: [signing_salt: "Uk+QjLpK"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :check_point, CheckPoint.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
