defmodule FrobotsUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.2.2",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixir: "~> 1.13.4",
      aliases: aliases(),
      releases: releases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:logger_file_backend, "~> 0.0.12"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:phoenix, "~> 1.6.5"},
      {:excoveralls, "~> 0.5.5", only: :test},
      {:junit_formatter, "~> 3.3", only: [:test]}
    ]
  end

  defp aliases do
    [
      "phx.routes": "phx.routes FrobotsWeb.Router"
    ]
  end

  defp releases do
    [
      frobots_backend: [
        applications: [frobots_web: :permanent, frobots: :permanent],
        cookie: "weknoweachother_frobotsnode",
        include_executables_for: [:unix],
        steps: [:assemble, :tar]
      ]
    ]
  end
end
