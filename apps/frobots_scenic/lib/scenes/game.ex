defmodule FrobotsScenic.Scene.Game do
  use Scenic.Scene
  alias Scenic.Graph
  alias Scenic.ViewPort
  import Scenic.Primitives, only: [rrect: 3, text: 3, circle: 3]

  defmodule Tank do
    defstruct scan: {0, 0},
              damage: 0,
              speed: 0,
              heading: 0,
              ploc: {0, 0},
              loc: {0, 0},
              id: nil,
              name: nil,
              status: :alive
  end
  defmodule Missile do
    defstruct ploc: {0, 0},
              loc: {0, 0},
              status: :flying
  end

  #Constants
  @name __MODULE__
  @graph Graph.build(font: :roboto, font_size: 16)
  @tank_size 10
  @tank_radius 8
  @miss_size 2
  @frame_ms 100
  @game_over_scene Snake.Scene.GameOver

  # Initialize the game scene

  def init(arg, opts) do
    viewport = opts[:viewport]
    IO.inspect arg
    # calculate the transform that centers the snake in the viewport
    {:ok, %ViewPort.Status{size: {vp_width, vp_height}}} = ViewPort.info(viewport)

    # how many tiles can the viewport hold in each diminesion


    # start a very simple animation timer
    {:ok, timer} = :timer.send_interval(@frame_ms, :frame)

    # The entire game state will be held here
    state = %{
      viewport: viewport,
      tile_width: vp_width,
      tile_height: vp_height,
      graph: @graph,
      frame_count: 1,
      frame_timer: timer,
      score: 0,
      frobots: arg,
      objects: %{tank:     %@name.Tank{},
                 missile:  %@name.Missile{},
                }
    }

    # update the graph and push it to the rendered

    graph =
      state.graph
      |> draw_score(state.score)
#      |> draw_game_objects(state.objects)

    { :ok, state, push: graph }
  end

  # Draw the score HUD
  defp draw_score(graph, score) do
    graph
    |> text("Score: #{score}", fill: :white )
  end

  # iterates over the object map, rendering each object.
  defp draw_game_objects(graph, object_map) do
    Enum.reduce(object_map, graph, fn {object_type, object_data}, graph ->
      draw_object(graph, object_type, object_data)
    end)
  end

  # snakes body is an array of coordinate pairs
  defp draw_object(graph, :tank, %@name.Tank{loc: {x,y}, name: name, id: id}) do
    draw_tank(graph, x,y, fill: :blue, id: id)
  end

  defp draw_object(graph, :missile, %@name.Missile{loc: {x,y}}) do
    draw_missile(graph, x, y, fill: :yellow )
  end

  # draw tanks as rounded rectarngles
  defp draw_tank(graph, x,y, opts) do
    tile_opts = Keyword.merge([translate: {x * @tank_size, y * @tank_size}], opts)
    graph |> rrect({@tank_size, @tank_size, @tank_radius}, tile_opts)
  end

  # draw missiles as circles
  defp draw_missile(graph, x,y, opts) do
    tile_opts = Keyword.merge([translate: {x * @miss_size, y * @miss_size}], opts)
    graph |> circle(@miss_size, tile_opts)
  end

  def handle_info(:frame, %{frame_count: frame_count} = state) do
    graph = state.graph |> draw_game_objects(state.objects) |> draw_score(state.score)
    {:noreply, %{state | frame_count: frame_count + 1}, push: graph}
  end


  defp add_score(state, amount) do
    update_in(state, [:score], &(&1 + amount))
  end

  #key board controls
  def handle_input(_input, _context, state), do: {:noreply, state}
end