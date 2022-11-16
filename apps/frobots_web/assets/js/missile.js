export class Missile {
    constructor(missile_name, x, y) {
        this.ploc = [0, 0];
        this.loc = [x, y];
        this.name = missile_name;
        this.timer = null;
        this.status = "flying";
    }

    update(x, y) {
        this.loc = [x, y];
        return this;
    }
}