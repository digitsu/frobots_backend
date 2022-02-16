---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by digitsu.
--- DateTime: 2021/12/01 11:28
---

--- sniper
--- goes to a random corner and scans for targets, moves if hit.
---
---
---
return function(state, ...)
  state = state or {}
  assert(
          type(state) == 'table',
          'Invalid state. Must receive a table'
  )
  math.randomseed( os.time() )
  math.random(); math.random(); math.random()
  state.type = "sniper"
  -- constants {corner x, corner y, scan angle from that corner}
  c1x = 50; c1y = 50; s1 = 0;
  c2x = 50; c2y = 950; s2 = 270;
  c3x = 950; c3y = 950; s3 = 180;
  c4x = 950; c4y = 50; s4 = 90;


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

  local function corner()
    local x,y;
    local angle;
    local new;
    new = math.random(4)
    if (new == corner) then
      corner = (new + 1) % 4
    else
      corner = new % 4
    end

    if (corner == 0) then
      x = c1x
      y = c1y
      sc = s1
    elseif (corner == 1) then
      x = c2x
      y = c2y
      sc = s2
    elseif (corner == 2) then
      x = c3x
      y = c3y
      sc = s3
    elseif (corner == 3) then
      x = c4x
      y = c4y
      sc = s4
    end
    fudgex = -5 +math.random(10)
    fudgey = -5 +math.random(10)
    angle = plot_course(x + fudgex,y + fudgey)
    drive(angle, 100)
    return {angle,x,y,sc}
  end

  local function camp() -- this is the 'main' while loop
    while state.dir < state.dest[4] + 90 do    --scan through 90 degree range
      state.d = damage()                  -- check for damage after each scan
      range = scan(state.dir, 3)          -- look at a direction
      if (range <= 700 and range > 0) then
        while (range > 0) do              -- keep firing while in range
          state.closest = range           -- set closest flag
          cannon(state.dir, range)        -- fire!
          range = scan(state.dir, 1)      -- check target again
          if (state.d < damage()) then -- sustained several hits
            range = 0                     -- goto new corner
            state.status = "cornering"
            state.dest = corner()
            state.d = damage()
            state.dir = state.dest[4]
            return state
          end
        end
        state.dir = state.dir - 10        -- back up scan just in case
      end
      state.dir = state.dir + 2           -- increment scan
      if (state.d < damage()) then       -- check for damage incurred
        state.status = "cornering"        -- we are hit move now
        state.dest = corner()
        state.d = damage()
        state.dir = state.dest[4]
        return state
      end
    end

    if (state.closest == 9999) then       -- check for any targets in range
      state.status = "cornering"          -- nothing, move to new corner
      state.dest = corner()
      state.d = damage()
      state.dir = state.dest[4]
    else
      state.dir = state.dest[4]           -- targets in range, resume.
    end

    state.closest = 9999
  end

  if state.status == nil then
    state.closest = 9999;
    state.d = damage()
    state.dest = corner()
    state.dir = state.dest[4]             -- dir is the direction to start target scan
    state.status = "cornering"
    state.timer = 30
    return state
  elseif state.status == "cornering" then
    if distance(loc_x(), loc_y(), state.dest[2],state.dest[3]) < 100 and speed() > 0 then
      state.status = "slowing"
      drive( state.dest[1], 20)
    else
      drive( state.dest[1], 100)
    end
    return state
  elseif state.status == "slowing" then
    state.timer = state.timer - 1
    if distance(loc_x(), loc_y(), state.dest[2],state.dest[3]) < 10 and speed() > 0 or state.timer < 0 then
      drive(0, 0)
      state.timer = 30
      state.status = "camping"
    end
    return state
  elseif state.status == "camping" then
    camp(state)
    return state
  end
  return state
end
