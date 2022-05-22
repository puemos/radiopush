defmodule Radiopush.MixProject do
  use Mix.Project

  def project do
    [
      app: :radiopush,
      version: "0.2.1",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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
      extra_applications: [:logger, :runtime_tools, :spotify_ex]
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
      {:bcrypt_elixir, "~> 3.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      {:ecto_sql, "~> 3.4"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:faker, "~> 0.16", only: [:test, :dev]},
      {:floki, ">= 0.27.0"},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:paginator, "~> 1.1"},
      {:phoenix, "~> 1.6.9"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.17"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:spotify_ex, "~> 2.3.0"},
      {:surface, "~> 0.7"},
      {:surface_formatter, "~> 0.7"},
      {:surface_heroicons, "~> 0.6"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 1.0"},
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
