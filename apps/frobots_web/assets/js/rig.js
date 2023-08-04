export class Rig {
  constructor(
    rig_name,
    x,
    y,
    heading,
    speed,
    rig_sprite,
    damage = 0,
    display_name = ''
  ) {
    this.scan = undefined
    this.damage = damage
    this.speed = speed
    this.heading = heading
    this.ploc = [0, 0]
    this.loc = [x, y]
    this.id = rig_name
    this.name = rig_name
    this.timer = undefined
    this.status = 'alive'
    this.fsm_debug = undefined
    this.class = undefined
    this.rig_sprite = rig_sprite
    this.scan_line = undefined
    this.display_name = display_name
  }

  update(x, y, heading, speed) {
    this.loc = [x, y]
    this.speed = speed
    this.heading = heading
    return this
  }

  update_scan(g, g2, deg, res) {
    this.scan_line = [g, g2]
    this.scan = [deg, res]
    return this
  }

  update_status(status) {
    this.status = status
    return this
  }

  update_fsm_debug(fsm_debug) {
    this.fsm_debug = fsm_debug
    return this
  }

  update_damage(damage) {
    this.damage = damage
    return this
  }
}
