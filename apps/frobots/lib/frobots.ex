defmodule Frobots do
  @moduledoc """
  Frobots keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  This module contains high level functions that help with managing the static Protobot LUA scripts in the source tree
  in sync with the database
  """
  @app :frobots
  @priv_dir "#{:code.priv_dir(@app)}"
  @templates_dir "templates"

  @frobot_paths %{
    rabbit: Path.join([@priv_dir, @templates_dir, "rabbit.lua"]),
    sniper: Path.join([@priv_dir, @templates_dir, "sniper.lua"]),
    random: Path.join([@priv_dir, @templates_dir, "random.lua"]),
    rook: Path.join([@priv_dir, @templates_dir, "rook.lua"]),
    tracker: Path.join([@priv_dir, @templates_dir, "tracker.lua"]),
    dummy: Path.join([@priv_dir, @templates_dir, "dummy.lua"]),
    target: Path.join([@priv_dir, @templates_dir, "target.lua"])
  }
  @frobot_types [
    {"Rabbit", :rabbit},
    {"Sniper", :sniper},
    {"Random", :random},
    {"Rook", :rook},
    {"Tracker", :tracker},
    {"Target", :target},
    {"Dummy", :dummy}
  ]

  # PUT ALL CONSTANT DATA AS ALIASES HERE
  @default_frobot_loadout [
    %{equipment_class: "Xframe", equipment_type: "Tank Mk1"},
    %{equipment_class: "Cannon", equipment_type: "Mk1"},
    %{equipment_class: "Scanner", equipment_type: "Mk1"},
    %{equipment_class: "Missile", equipment_type: "Mk1"}
  ]

  def frobot_paths() do
    @frobot_paths
  end

  def frobot_types() do
    @frobot_types
  end

  def default_frobot_loadout() do
    @default_frobot_loadout
  end

  def update_template_frobot(type) when is_binary(type) do
    name = String.to_atom(type)
    brain_code = File.read!(Map.get(@frobot_paths, name))
    frobot = Frobots.Assets.get_frobot(Atom.to_string(name))
    Frobots.Assets.update_frobot(frobot, %{brain_code: brain_code})
  end

  def update_template_frobot(type) do
    update_template_frobot(Atom.to_string(type))
  end

  def update_all_templates() do
    Enum.each(@frobot_types, fn {_name, type} -> update_template_frobot(type) end)
  end
end
