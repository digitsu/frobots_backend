
# Controlling your Tank

Frobots wouldn&rsquo;t be very interesting if they were just disembodied AIs floating around in virtual space. So in order for them to actually DO anything they are uploaded into a FROBOT CPU RIG, which is a Virtual Machine where they can execute their commands. Think of the CPU RIG as a &rsquo;cockpit&rsquo; for your FROBOT brain.

These RIGs are installed into a TANK, which is a physical object in the virtual world of the FROBOTS game grid. The tank can interact with its environment, like move, turn, and blow up other tanks!

The interface for the tank is as follows:

## 1. Scan

```lua
scan (degree,resolution)
```

The *scan()* function invokes the robot&rsquo;s scanner, at a specified degree and resolution. *scan()* returns **0** if no robots are within the scan range or a positive integer representing the range to the closest robot. Degree should be within the range{' '} **0-359**, otherwise degree is forced into **0-359** by a **modulo 360** operation, and made positive if necessary. Resolution controls the scanner&rsquo;s sensing resolution, up to **+/- 10 degrees**.

#### Examples

  ```lua
    range = scan(45,0) -- scan 45, with no variance
    range = scan(365,10) -- scans the range from 355 to 15
  ```

## 2. Cannon

```lua
cannon (degree,range)
```

The *cannon()* function fires a missile heading a specified range and direction. *cannon()* returns **1** (true) if a missile was fired, or **0** (false) if the cannon is reloading. Degree is forced into the range **0-359** as in *scan()*. Range can be{' '} **0-700**, with greater ranges truncated to 700.

#### Examples

  ```lua
  degree = 45    -- set a direction to test
  if (range=scan(degree,2) > 0) then --see if a target is there
    cannon(degree,range)  --fire a missile
  end
  ```

## 3. Drive

```lua
drive (degree,speed)
```

The *drive()* function activates the robot&rsquo;s drive mechanism, on a specified heading and speed. Degree is forced into the range **0-359** as in *scan()*. Speed is expressed as a percent, with 100 as maximum. A speed of **0** disengages the drive. Changes in direction can be negotiated at speeds of less than{' '} **50** percent.

#### Examples

  ```lua
  drive(0,100)  --head due east, at maximum speed
  drive(90,0)   --stop motion
  ```

## 4. Damage

```lua
damage()
```

The *damage()* function returns the current amount of damage incurred. *damage()* takes no arguments, and returns the percent of damage, **0-99**. (100 percent damage means the robot is completely disabled, thus no longer running!)

#### Examples

  ```lua
  d = damage();       --save current damage state
  ; ; ;               --other instructions
  if (d ~= damage()) then --compare current state to prior state
    drive(90,100)    --robot has been hit, start moving
    d = damage()     --get current damage again
  end
  ```

## 5. Speed

```lua
speed() // blocking
```

The *speed()* function returns the current speed of the robot.{' '} *speed()* takes no arguments, and returns the percent of speed,{' '} **0-100**. Note that *speed()* may not always be the same as the last *drive()*, because of acceleration and deceleration.

#### Examples

  ```lua
  drive(270,100)   --start drive, due south
  ; ; ;             --other instructions
  if (speed() == 0) then --check current speed
    drive(90,20)   --ran into the south wall, or another robot
  end
  ```

## 6. Location

```lua
loc_x() */ loc_y() /* blocking
```

The *loc_x()* function returns the robot&rsquo;s current **x** axis location. *loc_x()* takes no arguments, and returns{' '} **0-999**. The *loc_y()* function is similar to *loc_x()*, but returns the current **y** axis position.

#### Examples

  ```lua
  drive (180,50)  --start heading for west wall
  while (loc_x() > 20) do
    ;              --do nothing until we are close
  drive (180,0)   --stop drive
  end
  ```

 Note that the use of tight while loop like the above, while not illegal is not advised, as you will likely overload your **CPU RIG**, resulting in **CYCLE** penalties.
