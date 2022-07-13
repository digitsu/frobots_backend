defmodule FrobotsUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixir: "~> 1.9",
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
      {:excoveralls, "~> 0.5.5", only: :test}
    ]
  end

  defp aliases do
    [
      "phx.routes": "phx.routes FrobotsWeb.Router",
      test: ["cmd ./loadenv.sh", "test"],
      run: ["cmd ./loadenv.sh", "run"],
      compile: ["cmd ./loadenv.sh", "compile"]
    ]
  end

  defp releases do
    [
      frobots_web: [
        applications: [frobots_web: :permanent, frobots: :permanent],
        cookie: "weknoweachother_frobotsnode"
      ]
    ]
  end
end
