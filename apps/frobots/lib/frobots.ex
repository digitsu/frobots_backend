defmodule Frobots do
  @moduledoc """
  Frobots keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
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

  def frobot_paths() do
    @frobot_paths
  end

  def frobot_types() do
    @frobot_types
  end
end
