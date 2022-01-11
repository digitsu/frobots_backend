defmodule FrobotsConsole.Game do
  alias FrobotsConsole.UI
  alias Fubars.Arena
  require Logger
  alias Fubars.Frobot

  @tick 200
  @cleanup_tick 500

  defstruct width: 60,
            height: 60,
            game_win: nil,
            stat_win: nil,
            game_over: false,
            timer: nil,
            rigs: %{}, # a map of frobot name and value is a TankState or MissileState
            missiles: %{},
            tty: "",
            frobots: %{}

  def run(args) do
    IO.puts("starting")

    struct(FrobotsConsole.Game, args)
    |> init()
    |> UI.draw_screen()
    |> schedule_next_tick()
    |> start_frobots()
    |> loop()
    |> fini()

    :ok
  end

  defp init(state) do
    init_logger()

    state |> UI.init()
  end

  def init_logger do
    Logger.metadata(evt_type: :log) # makes the default evt_type just to be :log (so that it doesn't trigger the ui_event backend)
    Logger.configure(level: :info) # default level this overrides ALL BACKENDS! (this must be the most permissive level)
    Logger.configure_backend(:console, level: :info) #console backend level
    Logger.configure_backend({Fubars.LogBackend, :ui_event}, level: :info, game_pid: self()) #log backend level and save the listener pid
    Logger.debug("in game module --init_logger")
  end

  def start_frobots(state) do
    for {name, brain_path} <- state.frobots do
      #eventually should randomize the start order
      pid = FrobotsRigs.create_frobot(name, brain_path)
      Frobot.start(pid)
    end
    state
  end

  def loop(%{game_over: true} = state) do
    Arena.kill_all(Arena) #maybe needed as UI seems to hang on a keypress
    UI.game_over(state)
  end

  def loop(state) do
    next_state =
      receive do
        {:ex_ncurses, :key, key} ->
          Logger.debug("Got key #{key} or '#{<<key>>}''")
          handle_key(state, key)

        {:ui, evt} ->
          Logger.debug("#{IO.inspect evt}")
          state
          |> process_ui(evt)
          |> UI.draw_stats_screen()

        :tick ->
          state
          |> UI.draw_screen()
          |> schedule_next_tick()

        :cleanup ->
          Logger.debug("cleanup state")
          state
          |> do_cleanup()
      end

    loop(next_state)
  end



  defp fini(state) do
    IO.puts("in game fini")
    Arena.kill_all(Arena)
    Process.cancel_timer(state.timer)
    flush_ticks()
    UI.fini(state)
  end

  defp flush_ticks() do
    receive do
      :tick -> flush_ticks()
    after
      500 -> :ok
    end
  end

  defp handle_key(state, ?q) do
    #Arena.kill_all(Arena)
    %{state | game_over: true }
  end

  defp handle_key(state, _) do
    IO.puts("got a keypress")
    state
  end

  defp unmangle_values(map) do
    unmangle_tup = fn map, tup ->
      case Map.get(map, tup, nil) do
        nil ->
          map

        string_tup ->
          loc = List.to_tuple(Enum.map(String.split(string_tup, ","), &String.to_integer/1))
          Map.put(map, tup, loc)
      end
    end

    unmangle_int = fn map, tag ->
      case Map.get(map, tag) do
        nil -> map
        string_int -> Map.put(map, tag, String.to_integer(string_int))
      end
    end

    map
    |> unmangle_tup.(:mv)
    |> unmangle_tup.(:lc)
    |> unmangle_int.(:hd)
    |> unmangle_int.(:sp)
    |> unmangle_int.(:dm)
    |> unmangle_tup.(:ex)
    |> unmangle_tup.(:sc)
  end

  defp do_cleanup(state) do

    check_game_over = fn state ->
      if length(Map.keys(state.rigs)) < 2 do
        %{state | game_over: true }
      else
        state
      end
    end

    clean_killed = fn state, key ->
      Enum.reduce(Map.get(state, key), %{},
        fn {frobot, f_state}, acc ->
          case f_state.status do
            :destroyed -> acc
            :exploded -> acc
            _ -> Map.put(acc, frobot, f_state)
          end
        end)

      end

      # notice that we don't bother to clean up the timer: key in the f_state, because we are going to end up removing
      # the whole f_state all together.
      # However this does have the side effect of having several simultaneous rigs with scheduled cleanups, all being
      # cleaned up by the first timer that triggers. The rest of the cleanup events are made redundant
      # if we wanted to be pedantic we could call cancel_timer on all the other cleaned up structures on each call, but meh.
    state =
      state
      |> Map.put(:rigs, clean_killed.(state, :rigs))
      |> Map.put(:missiles, clean_killed.(state, :missiles))
      |> check_game_over.()

    state
  end

  defp process_ui(state, evt) do
    # update the tank and missile screen states from the messages received
    state_update =
      evt
      |> String.split("|")
      |> Enum.reduce(%{}, fn pair, result ->
        [key, value] = String.split(pair, ":")
        Map.put(result, String.to_atom(key), value)
      end)
      |> unmangle_values

    {frobot, f_state} = Map.pop(state_update, :nm)

    check_and_put = fn s1, k1, s2, k2 ->
      case Map.get(s2, k2, nil) do
        nil -> s1
        val -> Map.put(s1, k1, val)
      end
    end

    # these are checked for the first key that matches, so effectively only one of these messages can be
    # processed per event. This also determines the order in which the messages can be processed.
    update_frobot = fn old_state, f_state ->
      new_state = case f_state do
        %{:xx => _} -> #tank destroyed, this should trigger any death animation
          old_state |> Map.replace(:status, :destroyed)
        %{:mv => _} ->
          old_state |> check_and_put.(:ploc, old_state, :loc)
          |> check_and_put.(:loc, f_state, :mv)
          |> check_and_put.(:heading, f_state, :hd)
          |> check_and_put.(:speed, f_state, :sp)
        %{:dm => _} ->
          old_state |> check_and_put.(:damage, f_state, :dm)
        %{:kk => _} ->
          old_state |> schedule_next_cleanup()
        %{:cn => _} -> old_state
        %{:sc => _} -> old_state |> check_and_put.(:scan, f_state, :sc)
      end
      new_state
    end

    # these are checked in the order here, for the first match. 2 matches cases cannot be processed in the same
    # message, so be careful.
    update_missile = fn old_state, f_state ->
      #IO.puts( inspect( f_state ))
      new_state = case f_state do
        %{:ex => _} ->
          old_state
            |> Map.replace(:status, :exploded)
            |> check_and_put.(:loc, f_state, :ex)
        %{:kk => _} ->
          old_state |> schedule_next_cleanup()
        %{:mv => _} ->
          old_state |> check_and_put.(:ploc, old_state, :loc)
          |> check_and_put.(:loc, f_state, :mv)
        %{:ev => _} ->
          old_state
        %{:dt => _} ->
          old_state
        %{:rg => _} ->
          old_state
      end
      new_state
    end

    # its a message from a rig or missile
    if frobot != "arena" do
      cond do
        MapSet.member?(MapSet.new(Map.keys(state.rigs)), frobot) ->
          #IO.inspect f_state
          Map.put(
            state,
            :rigs,
            Map.update(state.rigs, frobot, %FrobotsConsole.Tank{}, &update_frobot.(&1, f_state))
          )

        MapSet.member?(MapSet.new(Map.keys(state.missiles)), frobot) ->
          #IO.inspect f_state
          Map.put(
            state,
            :missiles,
            Map.update(state.missiles, frobot, %FrobotsConsole.Missile{}, &update_missile.(&1, f_state))
          )

        true -> state
      end
    else # this is an update from Arena (on the creation of a rig)
      if Map.get(f_state, :tt) do
        id_tag = length(Map.keys(state.rigs)) + 1
        #UI.draw_chr(state, f_state.lc, {0,0}, ~s|#{id_tag}|)

        Map.put(
          state,
          :rigs,
          Map.put_new(state.rigs, f_state.tt, %FrobotsConsole.Tank{id: id_tag, loc: f_state.lc})
        )
      else
        if Map.get(f_state, :lc) do
          Map.put(
            state,
            :missiles,
            Map.put_new(state.missiles, f_state.mm, %FrobotsConsole.Missile{loc: f_state.lc})
          )
        else
          state
        end
      end
    end
  end

  defp schedule_next_tick(state) do
    timer = Process.send_after(self(), :tick, @tick)
    %{state | timer: timer}
  end

  defp schedule_next_cleanup(state) do
    timer = Process.send_after(self(), :cleanup, @cleanup_tick)
    %{state | timer: timer}
  end

end
