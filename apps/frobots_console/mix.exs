defmodule FrobotsConsole.MixProject do
  use Mix.Project

  def project do
    [
      app: :frobots_console,
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
      extra_applications: [:logger, :fubars, :frobots_cpu],
      mod: {FrobotsConsole.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:fubars, in_umbrella: true},
      {:frobots_cpu, in_umbrella: true},
      {:ex_ncurses, "~> 0.3.1"},
      {:logger_file_backend, "~> 0.0.12"},
    ]
  end
end
