import React, { useEffect, useState } from 'react'
import { Box, Button, Grid, Typography, Card } from '@mui/material'

import { useDispatch } from 'react-redux'
import { matchSimulationActions } from '../../redux/slices/matchSimulationSlice'
import { Game, tankHead } from '../../game_updated'
import { Tank } from '../../tank'
import * as PIXI from 'pixi.js'

export default (props: any) => {
  const {
    match,
    current_user_id,
    user_id,
    s3_base_url,
    arena,
    runSimulation,
    snapshot,
  } = props
  const dispatch = useDispatch()
  const isHost = user_id === current_user_id
  const { setSlots, setS3BaseUrl } = matchSimulationActions
  const [gameState, setGameState] = useState({ event: () => {} })
  const [isGameStarted, setisGameStarted] = useState(match.status === 'running')
  const {
    title,
    description,
    min_player_frobot,
    max_player_frobot,
    timer,
    slots,
    id,
    status,
  } = match
  const slotInfo = slots.map((slot) => {
    const slotType = slot.status?.toLowerCase()
    const slotImage = {
      open: '/images/frobot.svg',
      closed: '/images/grey_frobot.svg',
      host: '/images/red_frobot.svg',
      player: '/images/red_frobot.svg',
      protobot: '/images/yellow_frobot.svg',
      done: '/images/grey_frobot.svg',
    }
    if (slotType === 'open' || slotType === 'closed') {
      return {
        id: slot?.id,
        type: slot.status.toLowerCase(),
        url: slotImage[slotType],
        name: slotType === 'open' ? 'Open' : 'Closed',
        slotDetails: slot.frobot,
        current_user_id,
        frobot_user_id: slot.frobot_user_id,
      }
    } else if (slotType === 'done' && slot?.frobot === null) {
      return {
        id: slot?.id,
        type: slot.status.toLowerCase(),
        url: slotImage[slotType],
        name: 'Unoccupied',
        slotDetails: slot.frobot,
        current_user_id,
        frobot_user_id: slot.frobot_user_id,
      }
    } else {
      const isHostFrobot = slot?.frobot_user_id === user_id
      const frobotLabel = isHostFrobot
        ? `Host: ${slot.frobot?.name || ' '}`
        : `Player ${slot?.frobot_user_id || ' '}: ${slot.frobot?.name || ' '}`
      const name =
        slot?.slot_type?.toLowerCase() === 'protobot'
          ? `NPC : ${slot.frobot?.name || ' '}`
          : frobotLabel
      return {
        id: slot?.id,
        type: slot.status.toLowerCase(),
        url: slotImage[slot?.slot_type],
        name,
        slotDetails: slot.frobot,
        current_user_id,
        frobot_user_id: slot.frobot_user_id,
      }
    }
  })
  const showStartMatchButton = isHost && status === 'pending'

  useEffect(() => {
    if (showStartMatchButton) {
      startMatchHandler()
    }
  }, [])

  useEffect(() => {
    if (match.status === 'done') {
      window.location.href = `/arena/${match.id}/results`
    }
  }, [])

  useEffect(() => {
    const players =
      snapshot?.tank ||
      slots
        .filter((frobot) => frobot.frobot !== null)
        .map((frobot) => ({
          name: `${frobot.frobot.name}#${frobot.frobot_id}`,
          curr_loc: [0, 0],
          max_health: 100,
          health: 100,
          heading: 0,
          speed: 0,
        }))
    const tanks = [...players].map(
      ({ name, curr_loc, health, max_health, heading, speed }) => {
        var asset = tankHead(`${name}`)
        var tank_sprite = new PIXI.Sprite(
          PIXI.Texture.from('/images/' + asset + '.png')
        )
        const loc_x = curr_loc[0]
        const loc_y = curr_loc[1]
        tank_sprite.x = 0
        tank_sprite.y = 0
        tank_sprite.width = 15
        tank_sprite.height = 15
        const damage = max_health - health
        return {
          Tank: new Tank(
            `${name}`,
            loc_x,
            loc_y,
            heading,
            speed,
            tank_sprite,
            damage
          ),
          asset: { [`${name}`]: asset },
        }
      }
    )
    const game = new Game(
      tanks.map(({ Tank }) => Tank),
      [],
      {
        match_id: match.id,
        match_details: match,
        arena,
        s3_base_url,
        tankIcons: tanks.map(({ asset }) => asset),
      }
    )
    game.header()
    if (game !== null) {
      setGameState(game)
    }
  }, [])

  useEffect(() => {
    dispatch(setS3BaseUrl(s3_base_url))
  }, [s3_base_url])

  window.addEventListener(`phx:arena_event`, (e) => {
    gameState.event(e.detail)
  })

  const startMatchHandler = () => {
    setisGameStarted(true)
    runSimulation()
  }

  return (
    <Box width={'90%'} m={'auto'}>
      <Grid container mt={4}>
        <Grid item sm={12} md={9} lg={9} xl={9}>
          <Box id="game-arena" />
        </Grid>
        <Grid item sm={12} md={3} lg={3} xl={3}>
          <Box id="game-stats" />
        </Grid>
      </Grid>
    </Box>
  )
}
