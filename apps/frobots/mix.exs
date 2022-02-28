defmodule Fubars.Frobot.Cpu.MixProject do
  use Mix.Project

  def project do
    [
      app: :frobots_cpu,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :fubars],
      mod: {Frobots.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:fubars, in_umbrella: true},
      {:operate, "~> 0.1.0-beta.15"},
      {:luerl, github: "rvirding/luerl", branch: "develop", override: true},

    ]
  end
end
