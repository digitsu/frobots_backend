defmodule Frobots.Repo.Migrations.RandomizeFrobotAvatars do
  use Ecto.Migration

  alias Frobots.Assets
  alias Frobots.Accounts

  # this actually fixes any missing avatars by picking an random one, and also sets the avatars of the protobots if they are present.

  @tables %{users: &Accounts.list_users/0, frobots: &Assets.list_frobots/0}

  @prototype Assets.prototype_class()

  defp user_image_pool() do
    for x <- 1..20 do
      ~s"images/avatars/#{x}.png"
    end
  end

  defp frobot_image_pool() do
    for x <- 1..61 do
      ~s"images/frobots/#{x}.png"
    end
  end

  defp get_name(struct, type) when type == :frobots and struct.class == @prototype do
    ~s"images/protobots/S-#{String.downcase(struct.name)}.png"
  end

  defp get_name(struct, type) when type == :frobots and struct.name == "target" do
    ~s"images/protobots/S-target.png"
  end

  defp get_name(struct, type) when type == :frobots and struct.name == "dummy" do
    ~s"images/protobots/S-dummy.png"
  end

  defp get_name(_struct, type) when type == :frobots do
    Enum.random(frobot_image_pool())
  end

  defp get_name(_struct, _type) do
    Enum.random(user_image_pool())
  end

  defp get_pname(_struct, type, avatar) when type == :frobots do
    re = ~r/.*\/[S-]*[P-]*(.*).png/
    [str, mt] = Regex.run(re, avatar)
    String.replace(str, ~r"(.*\/)(.*)(.png)", "\\1" <> "P-" <> mt <> "\\3")
  end

  defp get_pname(_struct, _type, _avatar) do
    ""
  end

  defp save_me(struct, type) do
    case Map.has_key?(struct, :pixellated_img) do
      true ->
        execute ~s"update #{String.downcase(Atom.to_string(type))} set pixellated_img = '#{struct.pixellated_img}', avatar = '#{struct.avatar}' where id = '#{struct.id}' and avatar = '' returning id"

      _ ->
        execute ~s"update #{String.downcase(Atom.to_string(type))} set avatar = '#{struct.avatar}' where id = '#{struct.id}' and avatar = '' returning id"
    end
  end

  def up do
    for {type, get_fn} <- @tables do
      for table <- get_fn.() do
        avatar =
          case table.avatar do
            "" -> get_name(table, type)
            nil -> get_name(table, type)
            avatar -> avatar
          end

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
