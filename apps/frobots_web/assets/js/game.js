import * as PIXI from 'pixi.js';
import {Tank} from "./tank.js"
import {Missile} from "./missile.js"

// const trophyTexture = PIXI.Texture.from('images/trophy.png');
// const trophy = new PIXI.Sprite(trophyTexture);

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
    }

    event(payload) {
        var { args, event } = payload;
        console.log("Payload Received -->", payload);
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
        // Not sure how to get the tank class here.....
        var asset = tankHead("TankClass");
        var tank_sprite = new PIXI.Sprite(PIXI.Texture.from('images/' + asset + '.png'));
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

        new_tank.tank_sprite.x = new_tank.loc[0];
        new_tank.tank_sprite.y = new_tank.loc[1];
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

function tankHead(tank_class, _name) {
    var assets = ['blue1','blue2','blue3','blue4','blue5','blue6','blue7','blue8','blue9','red1','red2','red3','red4','red5','red6','red7','yellow1','yellow2','rabbit'];
    var asset = null;
    if (tank_class ==  "Proto") {
        asset = assets[Math.floor(Math.random()*7) + 8];
    } else if (tank_class == "Target") {
        asset = assets[Math.floor(Math.random()*2) + 15];
    } else {
        asset = assets[Math.floor(Math.random()*9)];
    }
    return asset;
}