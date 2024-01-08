import Config

# In test, use milliseconds instead of minute
config :check_point,
  convert_minutes: 10

config :check_point, CheckPoint.Repo,
  database: "check_point_repo",
  username: "randy",
  password: "",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :check_point, CheckPointWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DOBpBXR3+EIn/mfqKWj0cwO+7CmmeHpQAs/aalFm89hYBRRRfN+JFK7geJ5uHdks",
  server: false

# In test we don't send emails.
config :check_point, CheckPoint.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
