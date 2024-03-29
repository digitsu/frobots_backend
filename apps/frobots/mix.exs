defmodule Frobots.MixProject do
  use Mix.Project

  def project do
    [
      app: :frobots,
      version: "0.1.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
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
      mod: {Frobots.Application, []},
      extra_applications: [:logger]
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
      # {:fubars, in_umbrella: true},
      {:logger_file_backend, "~> 0.0.12"},
      {:phoenix_pubsub, "~> 2.0"},
      {:gettext, "~> 0.18"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:pbkdf2_elixir, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"},
      {:hackney, "~> 1.18"},
      {:bsv, "~> 2.1.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:sweet_xml, "~> 0.6"},
      {:exconstructor, "~> 1.2.7"},
      {:phoenix_client, "~> 0.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": [
        # "cmd source ../../.env",
        "ecto.create",
        "ecto.migrate",
        "run priv/repo/seeds/seeds.exs",
        "run priv/repo/seeds/seed_equipment.exs",
        "run priv/repo/seeds/seed_equipment_instance.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run apps/frobots/priv/repo/seeds/seed_equipment.exs --quiet",
        "run apps/frobots/priv/repo/seeds/seed_equipment_instance.exs --quiet",
        "test"
      ],
      testenv: ["cmd source ../../.env", "cmd echo $TEST_ENV"]
    ]
  end
end
