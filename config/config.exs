# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :radiopush,
  ecto_repos: [Radiopush.Repo]

config :radiopush, Radiopush.Repo, migration_primary_key: [type: :uuid]

config :esbuild,
  version: "0.25.4",
  default: [
    args: ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  # The project uses a Tailwind v3-style JS config and content scanning.
  version: "3.4.17",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=../priv/static/assets/app.tailwind.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :dart_sass,
  version: "1.93.2",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.tailwind.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures the endpoint
config :radiopush, RadiopushWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
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
