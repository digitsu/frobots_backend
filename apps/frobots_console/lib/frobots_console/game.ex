defmodule FrobotsConsole.Game do
  alias FrobotsConsole.UI
  alias Fubars.Arena
  require Logger

  @tick 200
  @cleanup_tick 500

  defstruct width: 60,
            height: 60,
            game_win: nil,
            game_over: false,
            timer: nil,
            frobots: %{}, # a map of frobot name and value is a TankState or MissileState
            missiles: %{}

  def run() do
    IO.puts("starting")

    %FrobotsConsole.Game{}
    |> init()
    |> UI.draw_screen()
    |> schedule_next_tick()
    |> loop()
    |> fini()

    :ok
  end

  def init_logger do
    Logger.metadata(evt_type: :log)
    Logger.configure(level: :info)
    Logger.configure_backend(:console, level: :info)
    # this will only pay attention to :ui evt_type
    Logger.configure_backend({Fubars.LogBackend, :log_backend}, level: :info, game_pid: self())
  end

  def loop(%{game_over: true} = state) do
    UI.game_over(state)
  end

  def loop(state) do
    next_state =
      receive do
        {:ex_ncurses, :key, key} ->
          Logger.debug("Got key #{key} or '#{<<key>>}''")
          handle_key(state, key)

        {:ui, evt} ->
          IO.puts "in process"
          process_ui(state, evt)

        :tick ->
          state
          |> UI.draw_screen()
          |> schedule_next_tick()

        :cleanup ->
          IO.puts "cleanup state"
          state
          |> do_cleanup()
      end

    loop(next_state)
  end


  def init(state) do
    Arena.kill_all!(Arena)
    init_logger()

    state
    |> UI.init()
    |> place_tanks()
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
    %{state | game_over: true, frobots: %{}, missiles: %{} }
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
  end

  defp do_cleanup(state) do
    clean_killed = fn state, key ->
      Enum.reduce(Map.get(state, key), %{},
        fn {frobot, f_state}, acc ->
          case f_state.status do
            :killed -> acc
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
      |> Map.put(:frobots, clean_killed.(state, :frobots))
      |> Map.put(:missiles, clean_killed.(state, :missiles))

    state
  end

  defp process_ui(state, evt) do
    # update the tank and missile screen states from the messages received
    IO.inspect evt
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

    update_frobot = fn old_state, f_state ->
      new_state = case f_state do
        %{:kk => _} ->
          old_state |> Map.replace(:status, :killed) |> schedule_next_cleanup()
        %{:mv => _} ->
          old_state |> check_and_put.(:ploc, old_state, :loc)
          |> check_and_put.(:loc, f_state, :mv)
          |> check_and_put.(:heading, f_state, :hd)
          |> check_and_put.(:speed, f_state, :sp)
        %{:dm => _} ->
          old_state |> check_and_put.(:damage, f_state, :dm)
      end
      new_state
    end

    update_missile = fn old_state, f_state ->
      new_state = case f_state do
        %{:ex => _} ->
       #   IO.puts "in exploding"
          old_state
            |> Map.replace(:status, :exploded)
            |> check_and_put.(:loc, f_state, :ex)
        %{:kk => _} ->
          old_state |> schedule_next_cleanup()
        %{:mv => _} ->
          old_state |> check_and_put.(:ploc, old_state, :loc)
          |> check_and_put.(:loc, f_state, :mv)
      end
      new_state
    end

    # its a message from arena.
    if frobot != "arena" do
      cond do
        MapSet.member?(MapSet.new(Map.keys(state.frobots)), frobot) ->
          Map.put(
            state,
            :frobots,
            Map.update(state.frobots, frobot, %FrobotsConsole.Tank{}, &update_frobot.(&1, f_state))
          )

        MapSet.member?(MapSet.new(Map.keys(state.missiles)), frobot) ->
          #IO.inspect state
          Map.put(
            state,
            :missiles,
            Map.update(state.missiles, frobot, %FrobotsConsole.Missile{}, &update_missile.(&1, f_state))
          )

        true -> state
      end
    else # this is an update from Arena (on the creation of a rig)
      if Map.get(f_state, :tt) do
        id_tag = length(Map.keys(state.frobots)) + 1
        UI.draw_chr(state, f_state.lc, {0,0}, ~s|#{id_tag}|)

        Map.put(
          state,
          :frobots,
          Map.put_new(state.frobots, f_state.tt, %FrobotsConsole.Tank{id: id_tag, loc: f_state.lc})
        )
      else
        UI.draw_chr(state, f_state.lc, {0,0}, "*")

        Map.put(
          state,
          :missiles,
          Map.put_new(state.missiles, f_state.mm, %FrobotsConsole.Missile{loc: f_state.lc})
        )
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

  def place_tanks(state) do
    # create tanks for each frobot, place them randomly in the arena
    # and store their pids.
    # location = {:rand.uniform(state.width - 2), :rand.uniform(state.height - 3)}
    location = {700, 999}
    {:ok, t1} = Arena.create(Arena, :demo1, :tank, loc: location)
    Fubars.Rig.go(t1)
    Fubars.Tank.drive(t1, 0, 100)
    location = {999, 999}
    {:ok, t2} = Arena.create(Arena, :demo2, :tank, loc: location)
    Fubars.Rig.go(t2)
    Fubars.Tank.drive(t2, 180, 100)
    location = {200, 200}
    {:ok, m1} = Arena.create(Arena, :mis1, :missile, loc: location, heading: 90)
    Fubars.Rig.go(m1)
    location = {600, 200}
    {:ok, m2} = Arena.create(Arena, :mis2, :missile, loc: location, heading: 80)
    Fubars.Rig.go(m2)
    state
  end

  def test_run(state \\ %FrobotsConsole.Game{}) do
    init_logger()
    location = {:rand.uniform(state.width - 2), :rand.uniform(state.height - 3)}
    Arena.create(Arena, :t1, :tank, loc: location)
  end
end
