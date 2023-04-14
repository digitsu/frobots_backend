defmodule Frobots.Avatars do
  @moduledoc """
  The Avatars context.
  """
  alias Frobots.Api
  require Logger

  # return frobot avatar images
  @spec get_frobot_avatars :: list
  def get_frobot_avatars() do
    case ExAws.S3.list_objects_v2(Api.get_s3_bucket_name(), prefix: "images/frobots")
         |> ExAws.request() do
      {:error, {:http_error, _, %{status_code: errcode}}} ->
        Logger.info(errcode)
        []

      {:ok, ret} ->
        contents = Map.get(ret.body, :contents, [])

        if length(contents) != 0 do
          avatar_images =
            Enum.map(ret.body.contents, &Map.get(&1, :key))
            |> Enum.filter(fn name -> !Regex.match?(~r/P-/, name) end)

          pixelated_images =
            Enum.map(ret.body.contents, &Map.get(&1, :key))
            |> Enum.filter(fn name -> Regex.match?(~r/P-/, name) end)

          avatar_images
          |> Enum.with_index(0)
          |> Enum.map(fn {avatar, index} ->
            id = index + 1

            %{
              id: id,
              avatar: avatar,
              pixellated_img:
                Enum.find(pixelated_images, fn name -> Regex.match?(~r/P-#{id}/, name) end)
            }
          end)
        else
          []
        end
    end
  end

  def list_user_avatars() do
    case ExAws.S3.list_objects_v2(Api.get_s3_bucket_name(), prefix: "images/avatars")
         |> ExAws.request() do
      {:error, _} ->
        ["https://via.placeholder.com/50.png"]

      {:ok, ret} ->
        Enum.map(Map.get(ret.body, :contents), &Map.get(&1, :key))
    end
  end

  def get_random_avatar() do
    Enum.random(list_user_avatars())
  end
end
