export class Tank {
    constructor() {
       this.scan = [0, 0];
       this.damage = 0;
       this.speed = 0;
       this.heading = 0;
       this.ploc = [0, 0];
       this.loc = [0, 0];
       this.id = null;
       this.name = null;
       this.timer = null;
       this.status = "alive";
       this.fsm_state = null;
       this.fsm_debug = null;
       this.class = null;
    }
}