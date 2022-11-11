import * as PIXI from 'pixi.js';
import {Tank} from "./tank.js"
import {Missile} from "./missile.js"

export class Game {
    constructor() {
        this.app = new PIXI.Application({ backgroundColor: 0x1099bb });
        this.tanks = [];
        this.missiles = [];
    }

    header() {
        document.body.appendChild(this.app.view);
        // Scale mode for all textures, will retain pixelation
        PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST;
        // Update with the cancel button
        const sprite = PIXI.Sprite.from('images/bullet.png');

        // Set the initial position
        sprite.anchor.set(0.5);
        sprite.x = this.app.screen.width - (this.app.screen.width / 25);
        sprite.y = this.app.screen.height / 25;

        // Opt-in to interactivity
        sprite.interactive = true;
        // Shows hand cursor
        sprite.buttonMode = true;

        // Alternatively, use the mouse & touch events:
        sprite.on('click', onClick); // mouse-only
        // sprite.on('tap', onClick); // touch-only
        this.app.stage.addChild(sprite);
    }

    event(payload) {
        var { args, event } = payload;
        console.log("Args", args);
        // get the create_tank separarted
        if (event == "create_tank" || event == "move_tank") {
          var tank_name = args[0];
          var [x, y] = args[1];
          var heading = args[2];
          var speed = args[3];
          this.moveTank(tank_name, x, y, heading, speed);
        } else if (event == "create_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
          this.moveMissile(missile_name, x, y)
        } else if (event == "move_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
          this.moveMissile(missile_name, x, y)
        }
      }
  
      moveTank(tank_name, x, y, heading, speed) {
        console.log(this)
        console.log("Move Tank", tank_name, x, y, heading, speed);
        var tank_index = this.tanks.findIndex(tank => tank.name == tank_name);
        if (tank_index == -1) {
            this.createTank(tank_name, x, y, heading, speed)
        } else {
           old_tank = this.tanks[tank_index]
           var new_tank = tank.update(x, y, heading, speed)
           this.tanks[tank_index] = new_tank
        }
        
      }

      moveMissile(missile_name, x, y) {
        console.log("Move Missle", missile_name, x, y);
        var missile_index = this.missiles.findIndex(missile => missile.name == missile_name);
        old_missile = this.missiles[missile_index]
        var new_missile = missile.update(x, y, heading, speed)
        this.missiles[missile_index] = new_missile
      }

      createTank(tank_name, x, y, heading, speed) {
        var new_tank = new Tank(tank_name, x, y, heading, speed);
        this.tanks.push(new_tank)
      }

      createMissile(missile_name, x, y) {
        var new_missile = new Missile(missile_name, x, y);
        this.missiles.push(new_missile)
      }

  
    // @spec handle_info({:move_tank, tank_name, tuple, integer, integer}, t) :: tuple
    // def handle_info({:move_tank, frobot, loc, heading, speed}, state) do
    //   state =
    //     state
    //     |> update_in?([:objects, :tank, frobot], &update_loc(&1, loc))
    //     |> update_in?([:objects, :tank, frobot], &update_heading_speed(&1, heading, speed))
  
    //   {:noreply, state}
    // end
  
    // @spec handle_info({:kill_tank, tank_name}, t) :: tuple
    // def handle_info({:kill_tank, frobot}, state) do
    //   state = update_in?(state, [:objects, :tank, frobot], &update_status(&1, :destroyed))
    //   {:noreply, state}
    // end
  
    // @spec handle_info({:create_miss, miss_name, tuple}, t) :: tuple
    // def handle_info({:create_miss, m_name, loc}, state) do
    //   state = put_in(state, [:objects, :missile, m_name], %@name.Missile{name: m_name, loc: loc})
  
    //   {:noreply, state}
    // end
  
    // @spec handle_info({:move_miss, miss_name, tuple}, t) :: tuple
    // def handle_info({:move_miss, m_name, loc}, state) do
    //   state = update_in?(state, [:objects, :missile, m_name], &update_loc(&1, loc))
    //   {:noreply, state}
    // end
  
    // @spec handle_info({:kill_miss, miss_name}, t) :: tuple
    // def handle_info({:kill_miss, m_name}, state) do
    //   # start a very simple animation timer
    //   {:ok, timer} = :timer.send_after(@animate_ms, {:remove, m_name, :missile})
    //   if timer == nil, do: raise(RuntimeError)
  
    //   state =
    //     state
    //     |> update_in?([:objects, :missile, m_name], &update_status(&1, :exploded))
    //     |> update_in?([:objects, :missile, m_name], &update_timer(&1, timer))
  
    //   {:noreply, state}
    // end

}

function onClick() {
    console.log("Send Cancel Event")
    // sprite.scale.x *= 1.25;
    // sprite.scale.y *= 1.25;
}