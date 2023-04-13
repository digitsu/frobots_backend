defmodule Frobots.Repo.Migrations.SeedImagesForFrobotsAndUsers do
  use Ecto.Migration
  alias Frobots.Assets
  alias Frobots.Accounts

  # keep images in sync!
  # s3cmd sync -P --delete-removed ./images/ s3://frobots-assets/images/
  # get the images pools from
  # {:ok, ret}=    ExAws.S3.list_objects_v2("frobots-assets", prefix: "images/frobots") |> ExAws.request

  @tables %{users: &Accounts.list_users/0, frobots: &Assets.list_frobots/0}

  @prototype Assets.prototype_class()
  @target Assets.target_class()
  @user_class Assets.default_user_class()

  defp user_image_pool() do
    [
      "images/avatars/1.png",
      "images/avatars/10.png",
      "images/avatars/11.png",
      "images/avatars/12.png",
      "images/avatars/13.png",
      "images/avatars/14.png",
      "images/avatars/15.png",
      "images/avatars/16.png",
      "images/avatars/17.png",
      "images/avatars/18.png",
      "images/avatars/19.png",
      "images/avatars/2.png",
      "images/avatars/20.png",
      "images/avatars/3.png",
      "images/avatars/4.png",
      "images/avatars/5.png",
      "images/avatars/6.png",
      "images/avatars/7.png",
      "images/avatars/8.png",
      "images/avatars/9.png"
    ]
  end

  defp frobot_image_pool() do
    [
      "images/frobots/1.png",
      "images/frobots/2.png",
      "images/frobots/3.png",
      "images/frobots/4.png",
      "images/frobots/5.png",
      "images/frobots/6.png",
      "images/frobots/7.png"
    ]
  end

  defp get_name(struct, type) when type == :frobots and struct.class == @prototype do
    ~s"images/protobots/#{String.capitalize(struct.name)}.png"
  end

  defp get_name(struct, type) when type == :frobots and struct.class == @target do
    ~s"images/protobots/Target.png"
  end

  defp get_name(_struct, type) when type == :frobots do
    Enum.random(frobot_image_pool())
  end

  defp get_name(_struct, _type) do
    Enum.random(user_image_pool())
  end

  defp get_pname(struct, type, avatar) when type == :frobots and struct.class == @user_class do
    re = ~r/.*\/(.*).png/
    [str, mt] = Regex.run(re, avatar)
    String.replace(str, mt, "P-" <> mt)
  end

  defp get_pname(_struct, _type, _avatar) do
    ""
  end

  defp save_me(struct, type) do
    case Map.has_key?(struct, :pixellated_img) do
      true ->
        execute ~s"update #{String.downcase(Atom.to_string(type))} set pixellated_img = '#{struct.pixellated_img}' where id = '#{struct.id}' returning id"

      _ ->
        nil
    end

    execute ~s"update #{String.downcase(Atom.to_string(type))} set avatar = '#{struct.avatar}' where id = '#{struct.id}' returning id"
  end

  def up do
    for {type, get_fn} <- @tables do
      for table <- get_fn.() do
        avatar = get_name(table, type)
        p_img = get_pname(table, type, avatar)

        table
        |> Map.replace(:avatar, avatar)
        |> Map.replace(:pixellated_img, p_img)
        |> save_me(type)
      end
    end
  end

  def down do
    IO.inspect("Rolling back image data")

    for table <- Map.keys(@tables) do
      execute ~s"update #{table} set avatar = '' returning id"

      case table do
        :frobots -> execute ~s"update #{table} set pixellated_img = '' returning id"
        _ -> nil
      end
    end
  end
end
