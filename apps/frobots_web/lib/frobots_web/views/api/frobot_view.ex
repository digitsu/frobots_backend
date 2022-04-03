defmodule FrobotsWeb.Api.FrobotView do
  use FrobotsWeb, :view
  alias FrobotsWeb.Api.FrobotView

  def render("index.json", %{frobots: frobots}) do
    %{data: render_many(frobots, FrobotView, "frobot.json")}
  end

  def render("show.json", %{frobot: frobot}) do
    %{data: render_one(frobot, FrobotView, "frobot.json")}
  end

  def render("frobot.json", %{frobot: frobot}) do
    %{
      id: frobot.id,
      name: frobot.name,
      brain_code: frobot.brain_code,
      class: frobot.class,
      xp: frobot.xp
    }
  end
end
