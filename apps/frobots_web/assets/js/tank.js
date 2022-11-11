export class Tank {
    constructor(tank_name, x, y, heading, speed) {
       this.scan = [0, 0];
       this.damage = 0;
       this.speed = speed;
       this.heading = heading;
       this.ploc = [0, 0];
       this.loc = [x, y];
       this.id = tank_name;
       this.name = tank_name;
       this.timer = null;
       this.status = "alive";
       this.fsm_state = null;
       this.fsm_debug = null;
       this.class = null;
    }

    update(x, y, heading, speed) {
        this.loc = [x, y];
        this.speed = speed;
        this.heading = heading;
    }
}