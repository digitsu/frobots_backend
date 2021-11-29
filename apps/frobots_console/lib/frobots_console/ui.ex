defmodule FrobotsConsole.UI do
  require Logger
  alias Fubars.Arena

  @explode_sprite " \u259a\u2590\u259e\n\u2591\u2593\u2588\u2592\u2591\n \u259e\u258c\u259a"
  @exp_line1 " \u259a\u2590\u259e"
  @exp_line2 "\u2591\u2593\u2588\u2592\u2591"
  @exp_line3 " \u259e\u258c\u259a"

  def init(state) do
    ExNcurses.initscr()
    ExNcurses.n_begin()
    win = ExNcurses.newwin(state.height + 0, state.width + 1, 1, 0)
    ExNcurses.listen()
    ExNcurses.noecho()
    ExNcurses.keypad()
    ExNcurses.curs_set(0)
    %{state | game_win: win}
  end

  def fini(state) do
    ExNcurses.stop_listening()
    ExNcurses.n_end()
    ExNcurses.endwin()

    state
  end

  def game_over(state) do
    center_text(state, " GAME OVER ")
    ExNcurses.refresh()
    flush_input()

    receive do
      {:ex_ncurses, :key, _} -> state
    end
  end

  def dump_text(state, txt) do
    center_text(state, txt)
    ExNcurses.refresh()
  end

  def flush_input() do
    receive do
      {:ex_ncurses, :key, _} -> flush_input()
    after
      100 -> :ok
    end
  end

  def draw_screen(state) do
    ExNcurses.clear()
    #ExNcurses.border()
    ExNcurses.mvaddstr(0, 2, "F.U.B.A.R.S.")
    ExNcurses.wclear(state.game_win)
    ExNcurses.wborder(state.game_win)
    draw_stats(state)
    draw_tanks(state)
    draw_missiles(state)
    ExNcurses.refresh()
    ExNcurses.wrefresh(state.game_win)
    state
  end

  def draw_tanks(state) do
    for tank_state <- Map.values(state.frobots) do
        draw_chr(state, tank_state.loc, tank_state.ploc, tank_state.id)
        #ExNcurses.refresh()
        #IO.inspect tank_state
    end

    state
  end

  @doc """
  changes normal x,y to ncurses y,x format
  """
  def scale_xy(state, {x,y}) do
    {trunc( x / Arena.height() * state.height),
      trunc((Arena.length() - y) / Arena.length() * state.width)}
  end

  def draw_chr(state, loc, ploc, chr) do

    {x,y} = scale_xy(state, loc)
    {px,py} = scale_xy(state, ploc)
    ExNcurses.wmove(state.game_win, py, px)
    ExNcurses.waddstr(state.game_win, " ")
    ExNcurses.wmove( state.game_win, y, x)
    ExNcurses.waddstr(state.game_win, to_string(chr))
  end

  defp draw_exp(state, loc, ploc ) do
    {x,y} = scale_xy(state, loc)
    {px,py} = scale_xy(state, ploc)
    ExNcurses.wmove(state.game_win, py, px )
    ExNcurses.waddstr(state.game_win, " ")
    ExNcurses.wmove(state.game_win, y-1, x-2)
    ExNcurses.waddstr(state.game_win, @exp_line1)
    ExNcurses.wmove(state.game_win, y, x-2)
    ExNcurses.waddstr(state.game_win, @exp_line2)
    ExNcurses.wmove(state.game_win, y+1, x-2)
    ExNcurses.waddstr(state.game_win, @exp_line3)

  end

  def draw_missiles(state) do
    for mis_state <- Map.values(state.missiles) do
        case mis_state.status do
          :flying ->
            draw_chr(state, mis_state.loc, mis_state.ploc, "\u2666")
          :exploded ->
            IO.puts "draw explode"
            draw_exp(state, mis_state.loc, mis_state.ploc )
          _ -> nil
        end
        #ExNcurses.refresh()
        #IO.inspect {mis_state, state}

    end

    state
  end

  def draw_stats(state) do
    # ExNcurses.mvaddstr(0, state.width - 20, "Score: #{inspect(state)}")
    state
  end

  defp center_text(state, str) do
    y = div(state.height, 2)
    x = div(state.width - String.length(str), 2)
    ExNcurses.mvaddstr(y, x, str)
  end
end
