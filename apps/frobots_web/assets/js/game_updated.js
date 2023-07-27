import * as PIXI from 'pixi.js'
import { Tank } from './tank.js'
import { Missile } from './missile.js'

// const trophyTexture = PIXI.Texture.from('images/trophy.png');
// const trophy = new PIXI.Sprite(trophyTexture);

export class Game {
  constructor(
    tanks,
    missiles,
    { match_id, match_details, arena, s3_base_url, tankIcons }
  ) {
    this.app = new PIXI.Application({
      width: 1000,
      height: 1000,
      antialias: true,
      transparent: false,
      resolution: 1,
    })
    this.app.ticker.minFPS = 60
    this.app.ticker.maxFPS = 120
    this.statusView = new PIXI.Application({
      width: 500,
      height: 1500,
      background: '#212B36',
      antialias: true,
      resolution: window.devicePixelRatio || 1,
    })
    this.tanks = tanks
    this.missiles = missiles
    this.match_details = match_details
    this.tankInstances = {}
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
      const bgUrl = `/${arena.image_url}`
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

    this.statsHeading = new PIXI.Text('Match Status', {
      fontSize: 30,
      lineHeight: 30,
      letterSpacing: 0,
      fill: 0xffffff,
      align: 'left',
      wordWrap: true,
      wordWrapWidth: this.statusView.renderer.width,
      antialias: true,
    })

    this.statsHeading.position.set(30, 30)
    this.statusView.stage.addChild(this.statsHeading)

    const tanksContainer = new PIXI.Container()
    const SPACING_X = 40 // horizontal spacing
    const SPACING_Y = 5 // vertical spacing
    let offsetY = 0
    let containerOffset = 0
    for (let i = 0; i < tanks.length; i++) {
      const tank = tanks[i]
      const asset = tankIcons[i][tank?.name]
      var tank_sprite = new PIXI.Sprite(
        PIXI.Texture.from('/images/' + asset + '.png')
      )
      if (this.app.stage && tank?.status !== 'disabled') {
        this.app.stage.addChild(tank.tank_sprite)
      }
      const container = new PIXI.Container()
      const name = tank.display_name || tank.name
      const nameText = new PIXI.Text(name?.split('#')[0]?.padEnd(12), {
        fill: '#ffffff',
      })
      const damageText = new PIXI.Text('dm: ' + tank.damage, {
        fontSize: 20,
        fill: '#00b739',
      })
      const speedText = new PIXI.Text('sp: ' + tank.speed, {
        fontSize: 20,
        fill: '#ffffff',
      })
      const headingText = new PIXI.Text('hd: ' + tank.heading, {
        fontSize: 20,
        fill: '#ffffff',
      })
      const scanText = new PIXI.Text('sc: ' + (tank.scan ? tank.scan : '-'), {
        fontSize: 20,
        fill: '#ffffff',
      })
      const statusText = new PIXI.Text(
        'st: ' + (tank.status ? tank.status : '-'),
        { fontSize: 20, fill: '#ffffff' }
      )
      const debugText = new PIXI.Text(
        'debug: ' + (tank.debug ? tank.debug : '-'),
        { fontSize: 20, fill: '#ffffff' }
      )

      tank_sprite.x = 0 // no horizontal spacing for nameText
      tank_sprite.y = offsetY
      tank_sprite.width = 25
      tank_sprite.height = nameText.height

      nameText.x = 40 // no horizontal spacing for nameText
      nameText.y = offsetY
      offsetY += nameText.height + SPACING_Y

      damageText.x = 40 // no horizontal spacing for damageText
      damageText.y = offsetY

      speedText.position.set(
        damageText.x + damageText.width + SPACING_X,
        offsetY
      ) // no horizontal spacing for speedText
      speedText.y = offsetY
      speedText.x = 180
      offsetY += speedText.height + SPACING_Y

      headingText.x = 40 // no horizontal spacing for headingText
      headingText.y = offsetY

      scanText.position.set(
        headingText.x + headingText.width + SPACING_X,
        offsetY
      ) // no horizontal spacing for speedText
      scanText.y = offsetY
      scanText.x = 180
      offsetY += scanText.height + SPACING_Y

      statusText.x = 40 // no horizontal spacing for statusText
      statusText.y = offsetY

      debugText.position.set(
        statusText.x + statusText.width + SPACING_X,
        offsetY
      ) // no horizontal spacing for speedText
      debugText.y = offsetY
      debugText.x = 180
      offsetY += debugText.height + SPACING_Y

      container.addChild(
        tank_sprite,
        nameText,
        damageText,
        speedText,
        headingText,
        scanText,
        statusText,
        debugText
      )
      container.position.y = containerOffset
      tanksContainer.addChild(container)
      this.tankInstances[tank.name] = container
      containerOffset += 50
    }

    if (this.statusView) {
      tanksContainer.position.set(30, 100)
      this.statusView.stage.addChild(tanksContainer)
    }

    //this.statusView.stage.addChild(this.stats)
  }

  header() {
    if (this.match_details.type != 'real') {
      //document.body.appendChild(this.app.view)
      const el = document.getElementById('garage-simulation')
      el.appendChild(this.app.view)
      const statusSection = document.getElementById('game-stats')
      statusSection.appendChild(this.statusView.view)
    } else {
      const el = document.getElementById('game-arena')
      el.appendChild(this.app.view)
      const statusSection = document.getElementById('game-stats')
      statusSection.appendChild(this.statusView.view)
    }
  }

  event(payload) {
    var { args, event } = payload

    if (event == 'create_tank') {
      if (!this.tanks.map(({ name }) => name).includes(args[0])) {
        var tank_name = args[0]
        var [x, y] = args[1]
        var heading = args[2]
        var speed = args[3]
        this.createTank(tank_name, x, y, heading, speed)
      }
    } else if (event == 'move_tank') {
      var tank_name = args[0]
      var [x, y] = args[1]
      var heading = args[2]
      var speed = args[3]
      if (this.tanks.map(({ name }) => name).includes(tank_name)) {
        this.moveTank(tank_name, x, y, heading, speed)
      } else {
        this.createTank(tank_name, x, y, heading, speed)
      }
    } else if (event == 'kill_tank') {
      var tank_name = args[0]
      var tank_index = this.tanks.findIndex((tank) => tank.name == tank_name)
      if (tank_index > -1) {
        var old_tank = this.tanks[tank_index]
        old_tank.tank_sprite.x = undefined
        old_tank.tank_sprite.y = undefined

        this.tanks.splice(tank_index, 1)
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
      var tank_name = args[0]
      var deg = args[1]
      var res = args[2]

      var tank_index = this.tanks.findIndex(
        (tank) => tank && tank.name == tank_name
      )
      var tank = this.tanks[tank_index]

      if (tank.scan_line != undefined) {
        tank.scan_line[0].clear()
        tank.scan_line[1].clear()
        tank.scan_line = undefined
      }

      var x = tank.loc[0]
      var y = tank.loc[1]
      var x2 = x + 700 * Math.cos((Math.PI * (deg - res)) / 180)
      var y2 = y + 700 * Math.sin((Math.PI * (deg - res)) / 180)
      var x3 = x + 700 * Math.cos((Math.PI * (deg + res)) / 180)
      var y3 = y + 700 * Math.sin((Math.PI * (deg + res)) / 180)

      let g = new PIXI.Graphics()
      g.position.set(7.5, 7.5)
      g.lineStyle(1, 0xffffff).moveTo(x, y).lineTo(x2, y2)

      let g2 = new PIXI.Graphics()
      g2.position.set(7.5, 7.5)
      g2.lineStyle(1, 0xffffff).moveTo(x, y).lineTo(x3, y3)

      var new_tank = tank.update_scan(g, g2, deg, res)
      this.tanks[tank_index] = new_tank
      this.app.stage.addChild(g, g2)
    } else if (event == 'damage') {
      var tank_name = args[0]
      var damage = args[1]

      var tank_index = this.tanks.findIndex(
        (tank) => tank && tank.name == tank_name
      )
      var old_tank = this.tanks[tank_index]
      var new_tank = old_tank.update_damage(damage)
      this.tanks[tank_index] = new_tank
    } else if (event == 'fsm_state') {
      var tank_name = args[0]
      var tank_status = args[1]

      var tank_index = this.tanks.findIndex(
        (tank) => tank && tank.name == tank_name
      )
      var old_tank = this.tanks[tank_index]
      var new_tank = old_tank.update_status(tank_status)
      this.tanks[tank_index] = new_tank
    } else if (event == 'fsm_debug') {
      var tank_name = args[0]
      var fsm_debug = args[1]
      var tank_index = this.tanks.findIndex(
        (tank) => tank && tank.name == tank_name
      )
      var old_tank = this.tanks[tank_index]
      var new_tank = old_tank.update_fsm_debug(fsm_debug)
      this.tanks[tank_index] = new_tank
    } else if (event == 'game_over') {
      console.log('Game Over', args)
      let winner = 'Winner: '
      for (let i = 0; i < args.length; i++) {
        winner += args[i] + ' '
      }
      console.log('Winner:', winner)
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
        setTimeout(() => {
          window.location.href = `/arena/${this.match_details.id}/results`
        }, 5000)
      } else {
        setTimeout(() => {
          window.location.href = `/garage/frobot/braincode?id=${this.match_details?.id}`
        }, 5000)
      }
    } else {
      console.log('Unhandled Payload Received -->', payload)
    }
    this.get_stats()
    return this.tanks
  }

  createTank(tank_name, x, y, heading, speed) {
    if (!this.tanks.map(({ name }) => name).includes(tank_name)) {
      var asset = tankHead(tank_name)
      var tank_sprite = new PIXI.Sprite(
        PIXI.Texture.from('/images/' + asset + '.png')
      )
      tank_sprite.x = x
      tank_sprite.y = y

      var new_tank = new Tank(tank_name, x, y, heading, speed, tank_sprite)
      this.tanks.push(new_tank)

      this.app.stage.addChild(tank_sprite)
    }
  }

  moveTank(tank_name, x, y, heading, speed) {
    var tank_index = this.tanks.findIndex(
      (tank) => tank && tank.name == tank_name
    )
    var old_tank = this.tanks[tank_index]
    if (old_tank.scan_line != undefined) {
      old_tank.scan_line[0].clear()
      old_tank.scan_line[1].clear()
      old_tank.scan_line = undefined
    }
    var new_tank = old_tank.update(x, y, heading, speed)
    this.tanks[tank_index] = new_tank

    new_tank.tank_sprite.x = new_tank.loc[0]
    new_tank.tank_sprite.y = new_tank.loc[1]
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
    for (let i = 0; i < this.tanks.length; i++) {
      this.get_stat(this.tanks[i])
    }
  }

  destroy() {
    this.app.destroy(true)
    this.statusView.destroy(true)
  }

  get_stat(tank) {
    const tankDetails = this.tankInstances[tank.name]
    tankDetails.children[2].text = `dm: ${tank.damage}`
    tankDetails.children[2].style.fill = this.getDamageColor(tank.damage)
    tankDetails.children[3].text = `sp: ${tank.speed}`
    tankDetails.children[4].text = `hd: ${tank.heading}`
    tankDetails.children[5].text = `sc: ${tank.scan ? tank.scan : '-'}`
    tankDetails.children[6].text = `st: ${tank.status ? tank.status : '-'}`
    tankDetails.children[7].text = `debug: ${tank.debug ? tank.debug : '-'}`
  }

  getDamageColor(damage) {
    let colorCode = '#00b739' // default color
    switch (true) {
      case damage > 80:
        colorCode = '#FF0000'
        break
      case damage > 60:
        colorCode = '#ffa500'
        break
      case damage > 40:
        colorCode = '#CC5500'
        break
      case damage > 20:
        colorCode = '#b8860b'
        break
      default:
        colorCode = '#00b739'
        break
    }
    return colorCode
  }
}

export function tankHead(tank_name) {
  console.log('Inside Tank Head', tank_name)

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
    tank_name.match('sniper') != null ||
    tank_name.match('random') != null ||
    tank_name.match('rook') != null ||
    tank_name.match('tracker') != null
  ) {
    asset = assets[Math.floor(Math.random() * 7) + 8]
  } else if (
    tank_name.match('dummy') != null ||
    tank_name.match('target') != null
  ) {
    asset = assets[Math.floor(Math.random() * 2) + 16]
  } else if (tank_name.match('rabbit') != null) {
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
