import * as PIXI from 'pixi.js';
import {Tank} from "./tank.js"
import {Missile} from "./missile.js"

const blue1 = PIXI.Sprite.from('images/blue1.png');
const blue2 = PIXI.Sprite.from('images/blue2.png');
const blue3 = PIXI.Sprite.from('images/blue3.png');
const blue4 = PIXI.Sprite.from('images/blue4.png');
const blue5 = PIXI.Sprite.from('images/blue5.png');
const blue6 = PIXI.Sprite.from('images/blue6.png');
const blue7 = PIXI.Sprite.from('images/blue7.png');
const blue8 = PIXI.Sprite.from('images/blue8.png');
const blue9 = PIXI.Sprite.from('images/blue9.png');
const red1 = PIXI.Sprite.from('images/red1.png');
const red2 = PIXI.Sprite.from('images/red2.png');
const red3 = PIXI.Sprite.from('images/red3.png');
const red4 = PIXI.Sprite.from('images/red4.png');
const red5 = PIXI.Sprite.from('images/red5.png');
const red6 = PIXI.Sprite.from('images/red6.png');
const red7 = PIXI.Sprite.from('images/red7.png');
const yellow1 = PIXI.Sprite.from('images/yellow1.png');
const yellow2 = PIXI.Sprite.from('images/yellow2.png');
const rabbit = PIXI.Sprite.from('images/rabbit.png');

const trophyTexture = PIXI.Texture.from('images/trophy.png');
const trophy = {
    sprite: new PIXI.Sprite(trophyTexture),
    z: 0,
    x: 0,
    y: 0,
};
// // Add the assets to load
// PIXI.Assets.add('blue1', 'images/blue1.png');
// PIXI.Assets.add('blue2', 'images/blue2.png');
// PIXI.Assets.add('blue3', 'images/blue3.png');
// PIXI.Assets.add('blue4', 'images/blue4.png');
// PIXI.Assets.add('blue5', 'images/blue5.png');
// PIXI.Assets.add('blue6', 'images/blue6.png');
// PIXI.Assets.add('blue7', 'images/blue7.png');
// PIXI.Assets.add('blue8', 'images/blue8.png');
// PIXI.Assets.add('blue9', 'images/blue9.png');
// PIXI.Assets.add('red1', 'images/red1.png');
// PIXI.Assets.add('red2', 'images/red2.png');
// PIXI.Assets.add('red3', 'images/red3.png');
// PIXI.Assets.add('red4', 'images/red4.png');
// PIXI.Assets.add('red5', 'images/red5.png');
// PIXI.Assets.add('red6', 'images/red6.png');
// PIXI.Assets.add('red7', 'images/red7.png');
// PIXI.Assets.add('yellow1', 'images/yellow1.png');
// PIXI.Assets.add('yellow2', 'images/yellow2.png');
// PIXI.Assets.add('rabbit', 'images/rabbit.png');

// // Allow the assets to load in the background
// PIXI.Assets.backgroundLoad(['blue1','blue2','blue3','blue4','blue5','blue6','blue7','blue8','blue9','red1','red2','red3','red4','red5','red6','red7','yellow1','yellow2','rabbit']);

export class Game {
    constructor() {
        this.app = new PIXI.Application({ width: 1000,
            height: 1000,
            backgroundColor: 0x00110F });
        this.tanks = [];
        this.missiles = [];
    }

    header() {
        console.log("Tanks (Inside Header) -->", this.tanks);
        document.body.appendChild(this.app.view);
        // Scale mode for all textures, will retain pixelation
        PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST;
        // Update with the cancel button
        const sprite = PIXI.Sprite.from('images/cancel.png');

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
        this.app.stage.addChild(trophy.sprite);
    }

    event(payload) {
        var { args, event } = payload;
        console.log("Tanks (Inside Event) -->", this.tanks);
        console.log("Argument Received -->", args);


        // Test Code
        trophy.x = trophy.x + 10
        trophy.y = trophy.y + 10

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
        console.log("Tanks (Inside Move Tank) -->", this.tanks);
        console.log("Move tank -->", tank_name, x, y, heading, speed);
        var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
        if (tank_index == -1) {
            this.createTank(tank_name, x, y, heading, speed)
        } else {
           var old_tank = this.tanks[tank_index]
           var new_tank = old_tank.update(x, y, heading, speed)
           this.tanks[tank_index] = new_tank
        }
        
      }

      moveMissile(missile_name, x, y) {
        console.log("Tanks (Inside Move Missile) -->", this.tanks);
        console.log("Move Missile -->", missile_name, x, y);
        var missile_index = this.missiles.findIndex(missile => missile.name == missile_name);
        var old_missile = this.missiles[missile_index]
        var new_missile = old_missile.update(x, y)
        this.missiles[missile_index] = new_missile
      }

      createTank(tank_name, x, y, heading, speed) {
        console.log("Tanks (Inside Create Tank) -->", this.tanks);
        console.log("Create Tank --->", tank_name, x, y, heading, speed);
        var new_tank = new Tank(tank_name, x, y, heading, speed);
        var assets = ['blue1','blue2','blue3','blue4','blue5','blue6','blue7','blue8','blue9','red1','red2','red3','red4','red5','red6','red7','yellow1','yellow2','rabbit'];
        var asset = assets[Math.floor(Math.random()*19)];
        this.drawObject(asset, x, y)
        this.tanks.push(new_tank)
      }

      createMissile(missile_name, x, y) {
        console.log("Tanks (Inside Create Missile) -->", this.tanks);
        console.log("Create Missile --->", missile_name, x, y);
        var new_missile = new Missile(missile_name, x, y);
        this.missiles.push(new_missile)
      }

      drawObject(asset, x, y) {
        console.log("DRAW OBJECT :", asset)
        blue1.anchor.set(0.5);
        // Set the initial position
        blue1.x = x;
        blue1.y = y;
        this.app.stage.addChild(blue1);

        // PIXI.Assets.load(asset_name).then((texture) => {
        //     console.log("LOADING......")
        //     // create a new Sprite from the resolved loaded texture
        //     const character = new PIXI.Sprite(texture);
        //     character.anchor.set(0.5);
        //     character.x = x;
        //     character.y = y;
        //     this.app.stage.addChild(character);
        // });
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