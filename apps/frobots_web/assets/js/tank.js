export class Tank {
    constructor(tank_name, x, y, heading, speed, tank_sprite) {
       this.scan = undefined;
       this.damage = 0;
       this.speed = speed;
       this.heading = heading;
       this.ploc = [0, 0];
       this.loc = [x, y];
       this.id = tank_name;
       this.name = tank_name;
       this.timer = undefined;
       this.status = "alive";
       this.fsm_debug = undefined;
       this.class = undefined;
       this.tank_sprite = tank_sprite;
       this.scan_line = undefined;
    }

    update(x, y, heading, speed) {
        this.loc = [x, y];
        this.speed = speed;
        this.heading = heading;
        return this;
    }

    update_scan(g, g2, deg, res) {
        this.scan_line = [g, g2];
        this.scan = [deg, res];
        return this;
    }

    update_status(status) {
        this.status = status;
        return this;
    }

    update_fsm_debug(fsm_debug) {
        this.fsm_debug = fsm_debug;
        return this;
    }

    update_damage(damage) {
        this.damage = damage;
        return this;
    }
}