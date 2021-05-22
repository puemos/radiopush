# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :radiopush,
  ecto_repos: [Radiopush.Repo]

config :radiopush, Radiopush.Repo, migration_primary_key: [type: :uuid]

# Configures the endpoint
config :radiopush, RadiopushWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "daeieHyyVE5xD0ZxvC+k1RMWKtsd01yOWK/k0lO/PMH2Y35lw/ZV9NLtjVf9Rkg0",
  render_errors: [view: RadiopushWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Radiopush.PubSub,
  live_view: [signing_salt: "Yf4l+pO2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
