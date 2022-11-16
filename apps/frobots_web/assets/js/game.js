import * as PIXI from 'pixi.js';
import {Tank} from "./tank.js"
import {Missile} from "./missile.js"

// const trophy = PIXI.Sprite.from('images/trophy.png');
const blue1 = PIXI.Texture.from('images/blue1.png');
const blue2 = PIXI.Texture.from('images/blue2.png');
const blue3 = PIXI.Texture.from('images/blue3.png');
const blue4 = PIXI.Texture.from('images/blue4.png');
const blue5 = PIXI.Texture.from('images/blue5.png');
const blue6 = PIXI.Texture.from('images/blue6.png');
const blue7 = PIXI.Texture.from('images/blue7.png');
const blue8 = PIXI.Texture.from('images/blue8.png');
const blue9 = PIXI.Texture.from('images/blue9.png');
const red1 = PIXI.Texture.from('images/red1.png');
const red2 = PIXI.Texture.from('images/red2.png');
const red3 = PIXI.Texture.from('images/red3.png');
const red4 = PIXI.Texture.from('images/red4.png');
const red5 = PIXI.Texture.from('images/red5.png');
const red6 = PIXI.Texture.from('images/red6.png');
const red7 = PIXI.Texture.from('images/red7.png');
const yellow1 = PIXI.Texture.from('images/yellow1.png');
const yellow2 = PIXI.Texture.from('images/yellow2.png');
const rabbit = PIXI.Texture.from('images/rabbit.png');

const trophyTexture = PIXI.Texture.from('images/trophy.png');
const trophy = new PIXI.Sprite(trophyTexture);

export class Game {
    constructor(tanks, missiles) {
        this.app = new PIXI.Application({ width: 1000,
            height: 1000,
            backgroundColor: 0x00110F });
        this.tanks = tanks;
        this.missiles = missiles;
    }

    header() {
        document.body.appendChild(this.app.view);
        // Scale mode for all textures, will retain pixelation
        PIXI.settings.SCALE_MODE = PIXI.SCALE_MODES.NEAREST;
        // Update with the cancel button
        const sprite = PIXI.Sprite.from('images/explode.png');

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

        this.app.stage.addChild(sprite);
        // this.app.stage.addChild(trophy);
    }

    event(payload) {
        var { args, event } = payload;
        console.log("PAYLOAD RECEIVED -->", payload);
        if (event == "create_tank") {
          var tank_name = args[0];
          var [x, y] = args[1];
          var heading = args[2];
          var speed = args[3];
          this.createTank(tank_name, x, y, heading, speed);
        } else if (event == "move_tank") {
            var tank_name = args[0];
            var [x, y] = args[1];
            var heading = args[2];
            var speed = args[3];
            this.moveTank(tank_name, x, y, heading, speed);
        } else if (event == "create_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
        //   this.moveMissile(missile_name, x, y);
        } else if (event == "move_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
        //   this.moveMissile(missile_name, x, y);
        }
      }

      createTank(tank_name, x, y, heading, speed) {
        var assets = ['blue1','blue2','blue3','blue4','blue5','blue6','blue7','blue8','blue9','red1','red2','red3','red4','red5','red6','red7','yellow1','yellow2','rabbit'];
        var asset = assets[Math.floor(Math.random()*19)]
        // map blue1 with the asset
        var tank_sprite = new PIXI.Sprite(blue1);
        tank_sprite.x = x;
        tank_sprite.y = y;
        var new_tank = new Tank(tank_name, x, y, heading, speed, tank_sprite);
        this.tanks.push(new_tank);
        this.app.stage.addChild(tank_sprite);
      }
  
      moveTank(tank_name, x, y, heading, speed) {
        var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
        var old_tank = this.tanks[tank_index];
        var new_tank = old_tank.update(x, y, heading, speed);
        this.tanks[tank_index] = new_tank;
        new_tank.tank_sprite.x = x;
        new_tank.tank_sprite.y = y;
      }

      moveMissile(missile_name, x, y) {
        console.log("Tanks (Inside Move Missile) -->", this.tanks);
        console.log("Move Missile -->", missile_name, x, y);
        var missile_index = this.missiles.findIndex(missile => missile.name == missile_name);
        var old_missile = this.missiles[missile_index]
        var new_missile = old_missile.update(x, y)
        this.missiles[missile_index] = new_missile
      }

      createMissile(missile_name, x, y) {
        console.log("Tanks (Inside Create Missile) -->", this.tanks);
        console.log("Create Missile --->", missile_name, x, y);
        var new_missile = new Missile(missile_name, x, y);
        this.missiles.push(new_missile)
      }
}

function onClick() {
    console.log("Send Cancel Event");
}