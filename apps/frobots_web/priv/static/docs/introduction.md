# Introduction

FROBOTS are functions. They are essentially recursive functions.

 Consciousness itself can be thought of as a recursive &rsquo;strange
          loop&rsquo; as Hofstadter puts it.

   Writing frobots is an exercise in creating strange loops. Albeit
          simple ones that are much simpler to comprehend. More complicated than
          say, a recursive function that calculates Fibonacci numbers or other
          mathematical series, Frobots are recursive loops that must execute a
          complex task. Namely that of winning a competitive game against other
          recursive functions.

In a way, Frobots are a microcosm of biological life, in its struggle
          to survive by passing its genes along.

 My inspiration for Frobots was evolutionary competitive games like
          **COREWARS** and competitive algorithm games like **CROBOTS**.

## Imperative vs Functional Programming

  To illustrate the difference between imperative programming style and
          the functional style of FROBOTs consider this algo to calculate the
          first **n** primes that end in &rsquo;3&rsquo; that employs a
          tradition &rsquo;while&rsquo; loop (in this case &rsquo;repeat&rsquo;)

```lua
print 'Hello World!'

function first_n_primes_ends_in_3(n)

  local count = 0
  local found = 0

  repeat
    count = count + 1
    if ends_in_3(count) and is_prime(count) then
       found = found + 1
       print( count )
    end
  until found == n
end
```

If written functionally, the repeat loop becomes a recursive call,
          made a bit easier thanks to the dynamic arity of Lua&rsquo;s
          functions.

```lua
function fnp3(n, num)
  if n <= 0 then
    return
  elseif num == nil then
    num = 0
  end

  if ends_in_3(num) and is_prime(num) then
    print(num)
    fnp3(n-1, num + 1)
  else
    fnp3(n, num + 1)
  end
end
```

## The Game Loop

 While the FROBOTs &rsquo;CPU&rsquo; process is responsible for
          &rsquo;calling the FROBOT&rsquo; again between cycles of the simulator
          making the recursion implicit, it is effectively the same. Any state
          that the next iteration of the FROBOT function requires is stored in
          the &rsquo;state&rsquo; lua table, which is the only parameter that is
          required in a FROBOT function.

 This is the example of the &rsquo;rabbit&rsquo; template FROBOT. Note
          that while more complex than the prime number example, containing
          locally defined functions internally, it essentially is the same
          thing: one big recursive function which takes state, changes the state
          and returns it. Only the recursion is not explicitly apparent, as it
          is done by the FROBOT Elixir process running the Lua VM in which the
          FROBOT is loaded.

```lua
return function(state, ...)
    state = state or {}
    assert(
            type(state) == 'table',
            'Invalid state. Must receive a table'
    )
    state.type = "rabbit"
    math.randomseed( os.time() )
    math.random(); math.random(); math.random()

    local function distance(x1,y1,x2,y2)
        local x = x1 -x2
        local y = y1 -y2
        local d = math.sqrt((x*x) + (y*y))
        return d
    end

    local function plot_course(xx,yy)
        local d
        local curx = loc_x()
        local cury = loc_y()
        local x = xx - curx
        local y = yy - cury

        if x == 0 then
            if yy > cury then
                d = 90.0
            else
                d = 270.0
            end
        else
            d = math.atan(y, x) * 180/math.pi
        end
        return d
    end

    local wanderspeed = 20
    local wandertimer = 5
    --- initial conditions
    if state.status == nil then
        state.status = "wandering"
        state.damage = damage()
        state.wander_lust = wandertimer
        state.dest = {math.random(1000), math.random(1000)} --- go somewhere in the grid
        state.course = plot_course(state.dest[1], state.dest[2])
        drive(state.course, wanderspeed)
        return state
    elseif state.damage ~= damage() then
        state.damage = damage()
        state.dest = {math.random(1000), math.random(1000)} --- go somewhere in the grid
        state.course = plot_course(state.dest[1], state.dest[2])
        drive(state.course, 100)
        state.status = "running"
        return state
    elseif state.status == "wandering" or state.status == "running" then
        if distance(loc_x(), loc_y(), state.dest[1], state.dest[2]) < 50 then
            -- stop
            drive(0, 0)
            state.status = "eating"
        end
        return state
    elseif state.status == "eating" and state.wander_lust > 0 then
        state.wander_lust = state.wander_lust -1
        return state
    elseif (state.status == "wandering" or state.status == "eating") and state.wander_lust < 0 then
        if state.status == "wandering" then
            state.status = "eating"
            drive(0,0)
        elseif state.status == "eating" then
            state.status = "wandering"
            state.dest = {math.random(1000), math.random(1000)} --- go somewhere in the grid
            state.course = plot_course(state.dest[1], state.dest[2])
            drive(state.course, wanderspeed)
        end
        state.wander_lust = wandertimer
        return state
    end
    return state
end
```

## Lua Programming Basics

  **Lua** is ideally suited for **FROBOTs** programming because there is no mental gymnastics required for people new to computer science. There is no cognitive load required in knowing the differences between arrays, lists, vectors, ints, floats, doubles etc.

  There are only 3 basic types and one special one in Lua:

  1. Booleans
  2. Numbers (floats)
  3. Tables (generic composite, enumerable data structure in which everything else falls under)
  4. nil (everything that isn&rsquo;t assigned)

  So basically you don&rsquo;t need to worry about int math, or double
  precisions etc. Arrays, Lists, Structures, dictionaries, maps etc are
  all Tables.

  As a beginner in programming this is ideal. You just stuff things in
  variables, and Lua will handle it.

  ```lua
    Lua 5.4.3  Copyright (C) 1994-2021 Lua.org, PUC-Rio
    > a = {1,2,3}
    > a
    table: 0x600001fd0140
    > a[1]
    1
    > a[2]
    2
    > a[2.0]
    2
    > a[2.1]
    nil
    > a[4/2]
    2
  ```

  Moreover, Tables are heterogenous, so you don&rsquo;t ever have to
  worry about mixing and matching. It truly is a data structure to suit
  ALL needs.

  See how we can add text indexed elements right on it there. note: The
  &rsquo;sizeof&rsquo; operator &rsquo;#&rsquo; gives the size of arrays
  in Lua.

  ```lua
    > a.newelem = "fancy!"
    > a["newelem"]
    fancy!
    > #a
    3
    > for k, v in pairs(a) do
    >> print(k, v)
    >> end
    1   1
    2   2
    3   3
    newelem fancy!
    >
  ```

 And Lua doesn&rsquo;t even care if you add things in order or not

   ```lua
    > a[4] = 10
    > #a
    4
    > for k, v in pairs(a) do
    >>print(k, v)
    >>end
    1   1
    2   2
    3   3
    4   10
    newelem fancy!
    > a[10] = "dave"
    > #a
    4 -- wait! you mean the other elems don't count in the size operator? Yes! Lua only counts contigious indexs as part of the size
    > for k, v in pairs(a) do
    >>print(k, v)
    >>end
    1   1
    2   2
    3   3
    4   10
    10  dave
    newelem fancy!
  ```

  Everything is there, but you cannot rely on the # operator to tell you  the size of the whole table, only the part of the table that actually  is a contiguous list.

  In no other language is there such a versatile one-size fits all data structure. This makes programming simple scripts in Lua very simple, and perfect for FROBOTs
