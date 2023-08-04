import * as PIXI from 'pixi.js'
import { Rig } from './rig.js'
import { Missile } from './missile.js'

// const trophyTexture = PIXI.Texture.from('images/trophy.png');
// const trophy = new PIXI.Sprite(trophyTexture);

export class Game {
  constructor(rigs, missiles, { match_id, match_details, arena, s3_base_url }) {
    this.app = new PIXI.Application({
      width: 1000,
      height: 1000,
      background: '#000000',
    })
    this.rigs = rigs
    this.missiles = missiles
    this.match_details = match_details
    if (match_details.type != 'real') {
      this.app.view.classList.add('garage-pixy-simulation')
      for (var i = 1; i < 1000; i = i + 10) {
        var vertical = new PIXI.Graphics()
        vertical.lineStyle(2, 0x00008b)
        vertical.moveTo(i, 0)
        vertical.lineTo(i, 1000)
        this.app.stage.addChild(vertical)
      }

      for (var i = 1; i < 1000; i = i + 10) {
        var horizontal = new PIXI.Graphics()
        horizontal.lineStyle(2, 0x00008b)
        horizontal.moveTo(0, i)
        horizontal.lineTo(1000, i)
        this.app.stage.addChild(horizontal)
      }
    } else {
      // Url for arena image
      const bgUrl = s3_base_url + arena.image_url
      //const bgUrl = '/images/arena_default.png'

      // adds static bg
      const background = PIXI.Sprite.from(bgUrl)
      background.width = this.app.renderer.width
      background.height = this.app.renderer.height
      this.app.stage.addChild(background)

      //ads black overlay
      // create a new Graphics object
      const overlay = new PIXI.Graphics()

      // draw a black rectangle that covers the entire stage
      overlay.beginFill(0x000000)
      overlay.drawRect(0, 0, this.app.renderer.width, this.app.renderer.height)
      overlay.endFill()

      // set the alpha of the Graphics object to 0.5 (50% opacity)
      overlay.alpha = 0.5

      // add the Graphics object to the stage
      this.app.stage.addChild(overlay)
    }

    this.stats = new PIXI.Text('', {
      fontSize: 20,
      lineHeight: 20,
      letterSpacing: 0,
      fill: 0xffffff,
      align: 'left',
    })
    this.app.stage.addChild(this.stats)
  }

  header() {
    if (this.match_details.type != 'real') {
      document.body.appendChild(this.app.view)
    } else {
      const game_arena = document.getElementById('game-arena')
      game_arena.style.width = '100vw'
      game_arena.style.height = '100vh'
      game_arena.appendChild(this.app.view)
    }
  }

  event(payload) {
    var { args, event } = payload

    if (event == 'create_rig') {
      if (!this.rigs.map(({ name }) => name).includes(args[0])) {
        var rig_name = args[0]
        var [x, y] = args[1]
        var heading = args[2]
        var speed = args[3]
        this.createRig(rig_name, x, y, heading, speed)
      }
    } else if (event == 'move_rig') {
      var rig_name = args[0]
      var [x, y] = args[1]
      var heading = args[2]
      var speed = args[3]
      if (this.rigs.map(({ name }) => name).includes(rig_name)) {
        this.moveRig(rig_name, x, y, heading, speed)
      } else {
        this.createRig(rig_name, x, y, heading, speed)
      }
    } else if (event == 'kill_rig') {
      var rig_name = args[0]
      var rig_index = this.rigs.findIndex((rig) => rig.name == rig_name)
      if (rig_index > -1) {
        var old_rig = this.rigs[rig_index]
        old_rig.rig_sprite.x = undefined
        old_rig.rig_sprite.y = undefined

        this.rigs.splice(rig_index, 1)
      }
    } else if (event == 'create_miss') {
      var missile_name = args[0]
      var [x, y] = args[1]
      this.createMissile(missile_name, x, y)
    } else if (event == 'move_miss') {
      var missile_name = args[0]
      var [x, y] = args[1]
      this.moveMissile(missile_name, x, y)
    } else if (event == 'kill_miss') {
      var missile_name = args[0]
      this.explodeMissile(missile_name)
    } else if (event == 'scan') {
      var rig_name = args[0]
      var deg = args[1]
      var res = args[2]

      var rig_index = this.rigs.findIndex((rig) => rig && rig.name == rig_name)
      var rig = this.rigs[rig_index]

      if (rig.scan_line != undefined) {
        rig.scan_line[0].clear()
        rig.scan_line[1].clear()
        rig.scan_line = undefined
      }

      var x = rig.loc[0]
      var y = rig.loc[1]
      var x2 = x + 700 * Math.cos((Math.PI * (deg - res)) / 180)
      var y2 = y + 700 * Math.sin((Math.PI * (deg - res)) / 180)
      var x3 = x + 700 * Math.cos((Math.PI * (deg + res)) / 180)
      var y3 = y + 700 * Math.sin((Math.PI * (deg + res)) / 180)

      let g = new PIXI.Graphics()
      g.position.set(0, 0)
      g.lineStyle(1, 0xffffff).moveTo(x, y).lineTo(x2, y2)

      let g2 = new PIXI.Graphics()
      g2.position.set(0, 0)
      g2.lineStyle(1, 0xffffff).moveTo(x, y).lineTo(x3, y3)

      var new_rig = rig.update_scan(g, g2, deg, res)
      this.rigs[rig_index] = new_rig
      this.app.stage.addChild(g, g2)
    } else if (event == 'damage') {
      var rig_name = args[0]
      var damage = args[1]

      var rig_index = this.rigs.findIndex((rig) => rig && rig.name == rig_name)
      var old_rig = this.rigs[rig_index]
      var new_rig = old_rig.update_damage(damage)
      this.rigs[rig_index] = new_rig
    } else if (event == 'fsm_state') {
      var rig_name = args[0]
      var rig_status = args[1]

      var rig_index = this.rigs.findIndex((rig) => rig && rig.name == rig_name)
      var old_rig = this.rigs[rig_index]
      var new_rig = old_rig.update_status(rig_status)
      this.rigs[rig_index] = new_rig
    } else if (event == 'fsm_debug') {
      var rig_name = args[0]
      var fsm_debug = args[1]
      var rig_index = this.rigs.findIndex((rig) => rig && rig.name == rig_name)
      var old_rig = this.rigs[rig_index]
      var new_rig = old_rig.update_fsm_debug(fsm_debug)
      this.rigs[rig_index] = new_rig
    } else if (event == 'game_over') {
      let winner = 'Winner: '
      for (let i = 0; i < args.length; i++) {
        winner += args[i] + ' '
      }
      var result = new PIXI.Text(winner, {
        fontSize: 20,
        lineHeight: 20,
        letterSpacing: 0,
        fill: 0xffffff,
        align: 'center',
      })
      result.position.x = 300
      result.position.y = 300
      this.app.stage.addChild(result)
      setTimeout(() => {
        this.app.destroy(true)
      }, 5000)
      if (this.match_details.type === 'real') {
        window.location.href = `/arena/${this.match_details.id}/results`
      } else {
        window.location.href = `/garage/frobot/braincode?id=${this.match_details?.id}`
      }
    } else {
      console.log('Unhandled Payload Received -->', payload)
    }
    this.stats.text = this.get_stats()
  }

  createRig(rig_name, x, y, heading, speed) {
    // Not sure how to get the rig class here.....
    var asset = rigHead(rig_name)
    var rig_sprite = new PIXI.Sprite(
      PIXI.Texture.from('/images/' + asset + '.png')
    )
    rig_sprite.x = x
    rig_sprite.y = y

    var new_rig = new Rig(rig_name, x, y, heading, speed, rig_sprite)
    this.rigs.push(new_rig)

    this.app.stage.addChild(rig_sprite)
  }

  moveRig(rig_name, x, y, heading, speed) {
    var rig_index = this.rigs.findIndex((rig) => rig && rig.name == rig_name)
    var old_rig = this.rigs[rig_index]
    if (old_rig.scan_line != undefined) {
      old_rig.scan_line[0].clear()
      old_rig.scan_line[1].clear()
      old_rig.scan_line = undefined
    }
    var new_rig = old_rig.update(x, y, heading, speed)
    this.rigs[rig_index] = new_rig

    new_rig.rig_sprite.x = new_rig.loc[0]
    new_rig.rig_sprite.y = new_rig.loc[1]
  }

  moveMissile(missile_name, x, y) {
    var missile_index = this.missiles.findIndex(
      (missile) => missile.name == missile_name
    )
    if (missile_index > -1) {
      var old_missile = this.missiles[missile_index]
      var new_missile = old_missile.update(x, y)
      new_missile.missile_sprite.x = new_missile.loc[0]
      new_missile.missile_sprite.y = new_missile.loc[1]
      this.missiles[missile_index] = new_missile
    }
  }

  explodeMissile(missile_name) {
    var explode_sprite = new PIXI.Sprite(
      PIXI.Texture.from('/images/explode.png')
    )

    var missile_index = this.missiles.findIndex(
      (missile) => missile.name == missile_name
    )
    if (missile_index > -1) {
      var old_missile = this.missiles[missile_index]
      old_missile.missile_sprite.x = undefined
      old_missile.missile_sprite.y = undefined

      explode_sprite.x = old_missile.loc[0]
      explode_sprite.y = old_missile.loc[1]
      this.app.stage.addChild(explode_sprite)

      this.missiles.splice(missile_index, 1)

      setTimeout(removeExplode, 300, explode_sprite)
    }
  }

  createMissile(missile_name, x, y) {
    const missile_sprite = new PIXI.Graphics()
    missile_sprite.beginFill(0xffa500)
    missile_sprite.drawCircle(5, 5, 2.5)
    missile_sprite.endFill()
    missile_sprite.x = x
    missile_sprite.y = y

    var new_missile = new Missile(missile_name, x, y, missile_sprite)
    this.missiles.push(new_missile)
    this.app.stage.addChild(missile_sprite)
  }

  get_stats() {
    let stats = ''
    for (let i = 0; i < this.rigs.length; i++) {
      stats += get_stat(this.rigs[i]) + '\n'
    }
    return stats
  }

  destroy() {
    this.app.destroy(true)
  }
}

// const cancelSimulation = document.getElementById('cancel-simulation')
// cancelSimulation.addEventListener('click',()=>{
//   this.app
// })

function get_stat(rig) {
  var name = rig.name.padEnd(12)
  var dm = 'dm: ' + rig.damage
  var sp = 'sp: ' + rig.speed
  var hd = 'hd: ' + rig.heading
  var sc = 'sc: ' + rig.scan
  var st = 'st: ' + rig.status
  var debug = 'debug: ' + rig.debug
  return (
    name +
    dm.padEnd(10) +
    sp.padEnd(10) +
    hd.padEnd(10) +
    sc.padEnd(15) +
    st.padEnd(17) +
    debug.padEnd(15)
  )
}

function rigHead(rig_name) {
  var assets = [
    'blue1',
    'blue2',
    'blue3',
    'blue4',
    'blue5',
    'blue6',
    'blue7',
    'blue8',
    'blue9',
    'red1',
    'red2',
    'red3',
    'red4',
    'red5',
    'red6',
    'red7',
    'yellow1',
    'yellow2',
    'rabbit',
  ]
  var asset = null
  if (
    rig_name.match('sniper') != null ||
    rig_name.match('random') != null ||
    rig_name.match('rook') != null ||
    rig_name.match('tracker') != null
  ) {
    asset = assets[Math.floor(Math.random() * 7) + 8]
  } else if (
    rig_name.match('dummy') != null ||
    rig_name.match('target') != null
  ) {
    asset = assets[Math.floor(Math.random() * 2) + 16]
  } else if (rig_name.match('rabbit') != null) {
    asset = 'rabbit'
  } else {
    asset = assets[Math.floor(Math.random() * 9)]
  }
  return asset
}

function removeExplode(explode_sprite) {
  explode_sprite.x = undefined
  explode_sprite.y = undefined
  return
}
