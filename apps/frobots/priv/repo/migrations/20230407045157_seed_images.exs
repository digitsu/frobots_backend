defmodule Frobots.Repo.Migrations.SeedImages do
  use Ecto.Migration
  alias Frobots.Assets

  @class_name_map %{
    bipedal: :chassis,
    tracks: :tank,
    hover: :hover,
    cannon: :cannon,
    scanner: :scanner,
    missile: :missile
  }

  @tables %{
    xframes: &Assets.list_xframes/0,
    cannons: &Assets.list_cannons/0,
    scanners: &Assets.list_scanners/0,
    missiles: &Assets.list_missiles/0
  }

  defp get_name(struct) when struct.class == :xframe do
    ~s"images/equipment/#{String.downcase(Atom.to_string(struct.type))}.png"
  end

  defp get_name(struct) do
    ~s"images/equipment/#{Atom.to_string(Map.get(@class_name_map, struct.class))}_#{String.downcase(Atom.to_string(struct.type))}.png"
  end

  defp save_me(struct) do
    IO.inspect(struct)

    execute ~s"update #{String.downcase(Atom.to_string(struct.class))}s set image = '#{struct.image}' where id = '#{struct.id}' returning id"
  end

  def up do
    for {_table_name, get_fn} <- @tables do
      for table <- get_fn.() do
        table
        |> Map.put(:image, get_name(table))
        |> save_me()
      end
    end
  end

  def down do
    IO.inspect("Rolling back image data")

    for table <- Map.keys(@tables) do
      execute ~s"update #{table} set image = ''"
    end
  end
end
