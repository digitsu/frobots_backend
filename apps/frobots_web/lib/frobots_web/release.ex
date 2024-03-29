defmodule FrobotsWeb.Release do
  @app :frobots

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    load_app()
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defmodule Seeder do
    @moduledoc """
    Release tasks for seeds.
    """

    require Logger

    @app :frobots

    @doc """
    Seed seeds file for repo.
    """
    @spec seed(Ecto.Repo.t(), String.t()) :: :ok | {:error, any()}
    def seed(repo, file_name) do
      load_app()

      case Ecto.Migrator.with_repo(repo, &eval_seed(&1, file_name)) do
        {:ok, {:ok, _fun_return}, _apps} ->
          :ok

        {:ok, {:error, reason}, _apps} ->
          Logger.error(reason)
          {:error, reason}

        {:error, term} ->
          Logger.error(term, [])
          {:error, term}
      end
    end

    @spec eval_seed(Ecto.Repo.t(), String.t()) :: any()
    defp eval_seed(repo, file_name) do
      seeds_file = get_path(repo, "seeds", file_name)

      if File.regular?(seeds_file) do
        {:ok, Code.eval_file(seeds_file)}
      else
        {:error, "Seeds file not found."}
      end
    end

    @spec get_path(Ecto.Repo.t(), String.t(), String.t()) :: String.t()
    defp get_path(repo, directory, file_name) do
      priv_dir = "#{:code.priv_dir(@app)}"

      repo_underscore =
        repo
        |> Module.split()
        |> List.last()
        |> Macro.underscore()

      Path.join([priv_dir, repo_underscore, directory, file_name])
    end

    @spec load_app() :: :ok | {:error, term()}
    defp load_app(), do: Application.load(@app)
  end
end
