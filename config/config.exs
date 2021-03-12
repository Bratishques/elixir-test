# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :testtask,
  ecto_repos: [Testtask.Repo]

# Configures the endpoint
config :testtask, TesttaskWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "B1K3ltUHgONONCn4c9G5buurHvhWOMZrBZ9r1ZzjjBPoJZ0Ug8nafJTo0wC5XGyZ",
  check_origin: false,
  render_errors: [view: TesttaskWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Testtask.PubSub,
  live_view: [signing_salt: "vkLpsbP9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
