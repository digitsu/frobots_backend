defmodule Frobots.Avatars do
  @moduledoc """
  The Avatars context.
  """
  alias Frobots.Api

  # return frobot avatar images
  @spec get_frobot_avatars :: list
  def get_frobot_avatars() do
    [
      %{
        id: 1,
        avatar: "images/frobots/1.png",
        pixellated_img: "images/frobots/P-1.png"
      },
      %{
        id: 2,
        avatar: "images/frobots/2.png",
        pixellated_img: "images/frobots/P-2.png"
      },
      %{
        id: 3,
        avatar: "images/frobots/3.png",
        pixellated_img: "images/frobots/P-3.png"
      },
      %{
        id: 4,
        avatar: "images/frobots/4.png",
        pixellated_img: "images/frobots/P-4.png"
      },
      %{
        id: 5,
        avatar: "images/frobots/5.png",
        pixellated_img: "images/frobots/P-5.png"
      },
      %{
        id: 6,
        avatar: "images/frobots/6.png",
        pixellated_img: "images/frobots/P-6.png"
      },
      %{
        id: 7,
        avatar: "images/frobots/7.png",
        pixellated_img: "images/frobots/P-7.png"
      }
    ]
  end

  def list_user_avatars() do
    case ExAws.S3.list_objects_v2(Api.get_s3_bucket_name(), prefix: "images/avatars")
         |> ExAws.request() do
      {:error, _} -> ["https://via.placeholder.com/50.png"]
      {:ok, ret} -> Enum.map(Map.get(ret.body, :contents), &Map.get(&1, :key))
    end
  end

  def get_random_avatar() do
    Enum.random(list_user_avatars())
  end
end
