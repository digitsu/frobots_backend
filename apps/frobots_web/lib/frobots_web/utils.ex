defmodule FrobotsWeb.Utils do
  @moduledoc """
  Utility functions for FrobotsWeb
  """
  require Logger

  def get_blog_posts() do
    with {:ok, url} <- Application.fetch_env(:frobots_web, :ghost_blog_url),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, data} <- Jason.decode(body) do
      data["posts"]
    else
      {:ok, _} ->
        Logger.info("Something other than HTTP 200 returned")
        []

      {:error, err} ->
        Logger.error(err)
        []

      :error ->
        Logger.error("GhostBlog: No Ghost URL!")
        []
    end
  end
end
