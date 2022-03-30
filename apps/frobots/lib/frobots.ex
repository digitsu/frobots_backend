defmodule Frobots do
  @moduledoc """
  Frobots keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @frobot_paths %{
    rabbit: "../frobots/templates/rabbit.lua",
    sniper: "../frobots/templates/sniper.lua",
    random: "../frobots/templates/random.lua",
    rook: "../frobots/templates/rook.lua",
    tracker: "../frobots/templates/tracker.lua",
    dummy: "../frobots/templates/dummy.lua",
    target: "../frobots/templates/target.lua"
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
