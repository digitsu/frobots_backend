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

        this.stats = new PIXI.Text("", {font:"50px Arial", fill:"white"});
        this.app.stage.addChild(this.stats);
    }

    header() {
      document.body.appendChild(this.app.view);
    }

    event(payload) {
        var { args, event } = payload;

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
        } else if (event == "kill_tank") {
          var tank_name = args[0];
          var tank_index = this.tanks.findIndex(tank => tank.name == tank_name);
          if (tank_index > -1) {
            var old_tank = this.tanks[tank_index];
            old_tank.tank_sprite.x = undefined;
            old_tank.tank_sprite.y = undefined;
            
            this.tanks.splice(tank_index, 1);
          };
        } else if (event == "create_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
          this.createMissile(missile_name, x, y);
        } else if (event == "move_miss") {
          var missile_name = args[0];
          var [x, y] = args[1];
          this.moveMissile(missile_name, x, y);
        } else if (event == "kill_miss") {
          var missile_name = args[0];
          this.explodeMissile(missile_name);
        } else if (event == "scan") {
          var tank_name = args[0];
          var deg = args[1];
          var res = args[2];

          var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
          var tank = this.tanks[tank_index];

          if (tank.scan_line != undefined) {
            tank.scan_line[0].clear();
            tank.scan_line[1].clear();
            tank.scan_line = undefined;
          };

          var x = tank.loc[0];
          var y = tank.loc[1];
          var x2 = x + 700 * Math.cos(Math.PI * (deg - res) / 180)
          var y2 = y + 700 * Math.sin(Math.PI * (deg - res) / 180)
          var x3 = x + 700 * Math.cos(Math.PI * (deg + res) / 180)
          var y3 = y + 700 * Math.sin(Math.PI * (deg + res) / 180)

          let g = new PIXI.Graphics();
          g.position.set(0, 0);
          g.lineStyle(1, 0xffffff)
            .moveTo(x, y)
            .lineTo(x2, y2);
          
          let g2 = new PIXI.Graphics();
          g2.position.set(0, 0);
          g2.lineStyle(1, 0xffffff)
            .moveTo(x, y)
            .lineTo(x3, y3);
        
          var new_tank = tank.update_scan(g, g2, deg, res);
          this.tanks[tank_index] = new_tank;
          this.app.stage.addChild(g, g2);
        } else if (event == "damage") {
          var tank_name = args[0];
          var damage = args[1];

          var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
          var old_tank = this.tanks[tank_index];
          var new_tank = old_tank.update_damage(damage);
          this.tanks[tank_index] = new_tank;
        } else if (event == "fsm_state") {
          var tank_name = args[0];
          var tank_status = args[1];

          var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
          var old_tank = this.tanks[tank_index];
          var new_tank = old_tank.update_status(tank_status);
          this.tanks[tank_index] = new_tank;
        } else if (event == "fsm_debug") {
          var tank_name = args[0];
          var fsm_debug = args[1];
          var tank_index = this.tanks.findIndex(tank => tank && tank.name == tank_name);
          var old_tank = this.tanks[tank_index];
          var new_tank = old_tank.update_fsm_debug(fsm_debug);
          this.tanks[tank_index] = new_tank;
        } else if (event == "game_over") {
          console.log("Game Over")
          this.app.destroy(true);
        } else {
          console.log("Unhandled Payload Received -->", payload);
        }

        this.stats.text = this.get_stats(this.tanks);
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
        if (old_tank.scan_line != undefined) {
          old_tank.scan_line[0].clear();
          old_tank.scan_line[1].clear();
          old_tank.scan_line = undefined;
        };
        var new_tank = old_tank.update(x, y, heading, speed);
        this.tanks[tank_index] = new_tank;

        new_tank.tank_sprite.x = new_tank.loc[0];
        new_tank.tank_sprite.y = new_tank.loc[1];
      }

      moveMissile(missile_name, x, y) {
        var missile_index = this.missiles.findIndex(missile => missile.name == missile_name);
        if (missile_index > -1) {
          var old_missile = this.missiles[missile_index];
          var new_missile = old_missile.update(x, y);
          new_missile.missile_sprite.x = new_missile.loc[0];
          new_missile.missile_sprite.y = new_missile.loc[1];
          this.missiles[missile_index] = new_missile;
        }
      }

      explodeMissile(missile_name) {
        var explode_sprite = new PIXI.Sprite(PIXI.Texture.from('images/explode.png'));

        var missile_index = this.missiles.findIndex(missile => missile.name == missile_name);
        if (missile_index > -1) {
          var old_missile = this.missiles[missile_index];
          old_missile.missile_sprite.x = undefined;
          old_missile.missile_sprite.y = undefined;

          explode_sprite.x = old_missile.loc[0];
          explode_sprite.y = old_missile.loc[1];
          this.app.stage.addChild(explode_sprite);
          
          this.missiles.splice(missile_index, 1);

          setTimeout(removeExplode, 300, explode_sprite);
        }
      }

      createMissile(missile_name, x, y) {
        var missile_sprite = new PIXI.Sprite(PIXI.Texture.from('images/bomb.png'));
        missile_sprite.x = x;
        missile_sprite.y = y;

        var new_missile = new Missile(missile_name, x, y, missile_sprite);
        this.missiles.push(new_missile);
        this.app.stage.addChild(missile_sprite);
      }

      get_stats(tanks) {
        let stats = "";
        for (let i = 0; i < tanks.length; i++) {
          stats += get_stat(tanks[i]) + "\n";
        }

        return stats;
      }

}

function onClick() {
    console.log("Send Cancel Event");
}

function get_stat(tank) {
  return tank.name + "  " + "  dm:  " + tank.damage + "  sp:  " + tank.speed + "  hd:  " + tank.heading + "  sc:  " + tank.scan + "  st:  " + tank.status + "  debug:  " + tank.debug;
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

function removeExplode(explode_sprite) {
  explode_sprite.x = undefined;
  explode_sprite.y = undefined;
  return;
}