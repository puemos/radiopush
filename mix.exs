defmodule Radiopush.MixProject do
  use Mix.Project

  def project do
    [
      app: :radiopush,
      version: "0.2.2",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Radiopush.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.3"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dart_sass, "~> 0.7", runtime: Mix.env() == :dev},
      {:ecto_sql, "~> 3.13"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:faker, "~> 0.18", only: [:test, :dev]},
      {:floki, "~> 0.38"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:lazy_html, ">= 0.1.0", only: :test},
      {:mix_test_watch, "~> 1.4", only: :dev, runtime: false},
      {:mox, "~> 1.2", only: :test},
      {:paginator, "~> 1.2"},
      {:phoenix, "~> 1.8.3"},
      {:phoenix_ecto, "~> 4.7"},
      {:phoenix_html, "~> 4.3"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_view, "~> 1.1.22"},
      {:postgrex, "~> 0.22"},
      {:req, "~> 0.5"},
      {:bandit, "~> 1.8"},
      {:tailwind, "~> 0.4", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.3"},
      {:typed_struct, "~> 0.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets", "assets.build"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "assets.build": [
        "esbuild default",
        "sass default",
        "tailwind default"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default",
        "tailwind default --minify",
        "phx.digest"
      ]
    ]
  end
end
