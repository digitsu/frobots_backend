import React, { useEffect, useState } from 'react'
import { Box, Button, Grid, Typography, Card } from '@mui/material'

import { useDispatch } from 'react-redux'
import { matchSimulationActions } from '../../redux/slices/matchSimulationSlice'
import { Game, rigHead } from '../../game_updated'
import { Rig } from '../../rig'
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
  const [isGameStarted, setisGameStarted] = useState(
    match.status === 'running' || isHost
  )
  const { slots, status } = match

  const showStartMatchButton = isHost
  useEffect(() => {
    if (isHost && match.status === 'pending') {
      startMatchHandler()
    }
  }, [])

  useEffect(() => {
    if (match.status === 'done') {
      window.location.href = `/arena/${match.id}/results`
    }
  }, [])

  useEffect(() => {
    if (showStartMatchButton || isGameStarted) {
      const players =
        snapshot?.rig.filter(({ status }) => status !== 'disabled') ||
        slots
          .filter((frobot) => frobot.frobot !== null)
          .map((slot) => ({
            name: `${slot.frobot.name}#${slot.id}`,
            curr_loc: [0, 0],
            max_health: 100,
            health: 100,
            heading: 0,
            speed: 0,
            display_name: slot.frobot.name,
          }))
      const rigs = [...players].map(
        ({
          name,
          curr_loc,
          health,
          max_health,
          heading,
          speed,
          display_name,
        }) => {
          var asset = rigHead(`${name}`)
          var rig_sprite = new PIXI.Sprite(
            PIXI.Texture.from('/images/' + asset + '.png')
          )
          const loc_x = curr_loc[0]
          const loc_y = curr_loc[1]
          rig_sprite.x = 0
          rig_sprite.y = 0
          rig_sprite.width = 15
          rig_sprite.height = 15
          const damage = max_health - health
          return {
            Rig: new Rig(
              name,
              loc_x,
              loc_y,
              heading,
              speed,
              rig_sprite,
              damage,
              display_name
            ),
            asset: { [name]: asset },
          }
        }
      )
      const game = new Game(
        rigs.map(({ Rig }) => Rig),
        [],
        {
          match_id: match.id,
          match_details: match,
          arena,
          s3_base_url,
          rigIcons: rigs.map(({ asset }) => asset),
        }
      )
      game.header()
      if (game !== null) {
        setGameState(game)
      }
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
  const MatchWaitingScreen = () => {
    return (
      <Box>
        <Typography variant="h3">
          Waiting for host to start the match.
        </Typography>
      </Box>
    )
  }
  return (
    <Box width={'90%'} m={'auto'} pb={4}>
      {isGameStarted ? (
        <Grid container mt={4}>
          <Grid item sm={12} md={9} lg={9} xl={9}>
            <Box id="game-arena" />
          </Grid>
          <Grid item sm={12} md={3} lg={3} xl={3}>
            <Box id="game-stats" />
          </Grid>
        </Grid>
      ) : (
        <Grid
          container
          justifyContent={'center'}
          alignItems={'center'}
          minHeight={'calc(100vh - 152px)'}
        >
          <Grid item>
            <Box>
              <MatchWaitingScreen />
            </Box>
          </Grid>
        </Grid>
      )}
    </Box>
  )
}
