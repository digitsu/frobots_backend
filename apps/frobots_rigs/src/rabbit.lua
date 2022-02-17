---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by digitsu.
--- DateTime: 2021/12/01 11:28
---

--- rabbit
--- rabbit runs around the field randomly
--- and never fires anything, just a moving target

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
    local wandertimer = 20
    --- initial conditions
    if state.status == nil then
        state.status = "wandering"
        state.damage = damage()
        state.wander_lust = wandertimer
        state.dest = {math.random(1000), math.random(1000)} --- go somewhere in the grid
        state.course = plot_course(state.dest[1], state.dest[2])
        drive(state.course, wanderspeed)
        return state
    end

    if state.damage ~= damage() and state.status ~= "running" then
        state.damage = damage()
        state.dest = {math.random(1000), math.random(1000)} --- go somewhere in the grid
        state.course = plot_course(state.dest[1], state.dest[2])
        drive(state.course, 100)
        state.status = "running"
        return state
    end

    if state.status == "wandering" or state.status == "running" then
        if distance(loc_x(), loc_y(), state.dest[1], state.dest[2]) < 50 then
            -- stop
            drive(0, 0)
            state.status = "eating"
        end
        state.wander_lust = state.wander_lust -1
        return state
    end

    if (state.status == "wandering" or state.status == "eating") and state.wander_lust < 0 then
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