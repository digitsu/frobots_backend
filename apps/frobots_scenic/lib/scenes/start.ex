defmodule FrobotsScenic.Scene.Start do
  @moduledoc """
  Sample scene.
  """
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.ViewPort
  import Scenic.Primitives
  import Scenic.Components

  @frobot_paths %{rabbit: "apps/frobots_rigs/src/rabbit.lua",
                  sniper: "apps/frobots_rigs/src/sniper.lua",
                  random: "apps/frobots_rigs/src/random.lua" }
  @body_offset 60

  @header [
    text_spec("FUBARs", translate: {15, 20}),
    # this button will cause the scene to crash.
    button_spec("Fight!", id: :btn_run, theme: :danger, t: {370, 0})
  ]

  ##
  # Now the specs for the various components we'll display
  @dropdowns [
            dropdown_spec(
              {
                [{"Rabbit", :rabbit}, {"Sniper", :sniper}, {"Random", :random}],
                :rabbit
              },
              id: :frobot1,
              translate: {0, 0}
            ),
            dropdown_spec(
              {
                [{"Rabbit", :rabbit}, {"Sniper", :sniper}, {"Random", :random}],
                :rabbit
              },
              id: :frobot2,
              translate: {100, 0}
            ),
            dropdown_spec(
              {
                [{"Rabbit", :rabbit}, {"Sniper", :sniper}, {"Random", :random}],
                :rabbit
              },
              id: :frobot3,
              translate: {200, 0}
            )
  ]

  ##
  # And build the final graph
  @graph Graph.build(font: :roboto, font_size: 24, theme: :dark)
         |> add_specs_to_graph(
              [
                @header,
                group_spec(@dropdowns, t: {15, 74})
              ],
              translate: {0, @body_offset + 20}
            )

           # Nav and Notes are added last so that they draw on top

  @event_str "Event received: "

  # ============================================================================

  def init(_, opts) do
    viewport = opts[:viewport]
    state = %{
      viewport: viewport,
      graph: @graph,
      frobots:          %{frobot1: :rabbit,
                          frobot2: :rabbit,
                          frobot3: :rabbit},
    }

    {:ok, state, push: @graph}
  end

  defp load_frobots(frobots) do
    Map.new(Enum.map(frobots, fn {k,v} -> {Atom.to_string(k), @frobot_paths[v]} end))
  end

  defp go_to_first_scene(%{viewport: vp, frobots: frobots}) do
    ViewPort.set_root(vp, {FrobotsScenic.Scene.Game, load_frobots(frobots)})
  end

  # start the game
  def filter_event({:click, :btn_run}, _, state) do
    go_to_first_scene(state)
    {:halt, state}
  end

  def filter_event({:value_changed, dropdown, val}, _, state) do
    state = put_in(state, [:frobots, dropdown], val)
    {:halt, state, push: state.graph}
  end
end
