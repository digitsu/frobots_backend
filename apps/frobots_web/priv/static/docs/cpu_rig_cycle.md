# CPU Rig Cycles

Even though you can write whatever Lua code you wish, due to the limitations of your CPU rig, there is an advisable way to write your frobot, vs not so optimal ways. Each call to the Rig interface has a CPU cycle cost, and each game loop cycle, each FROBOT is given a limited fixed number of cycles that it can use to do something with. If the number of cycles are expended, then the FROBOT will brain will overload, and be put into a cooldown state unable to do anything until the next cycle (and also incurring a penalty time of 200ms). Therefore, while it is possible to write Frobot code that will use tight unbounded loops, it is much more efficient to write FROBOT code that will do just 1 or 2 things each cycle, and then return its state, progressing to its next cycle.

A CPU RIG basically runs FROBOT braincode in a loop, starting with an empty state variable, and each time it runs the FROBOT brain code, it takes the returned mutated state variable, and runs the FROBOT code again with state variable output from the previous loop. Therefore, think of your FROBOT braincode function as simply constantly looping calling itself with the state variable that you have full control over, so you can pass messages or state between loops by putting flags or variables in the state variable.

There is a special state element called &rsquo;status&rsquo; in your frobots state table, which will be used to print to the GUI what the current state your frobot is in. You may optionally use it if you wish to see what your frobot is doing during the simulation.

Currently the CPU MkI has a size 60 cycle buffer. The Rig interface cycle costs attributes are set as:

``` lua
@overload_penalty 2000
@interface_cost_map %{
  scan: 2,
  cannon: 25,
  drive: 40,
  loc_x: 1,
  loc_y: 1,
  speed: 1,
  damage: 1
}
```
