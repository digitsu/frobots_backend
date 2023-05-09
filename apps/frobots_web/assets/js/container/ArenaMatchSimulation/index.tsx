import React, { useEffect, useState } from 'react'
import { Box, Button, Grid, Typography, Card } from '@mui/material'

import { useDispatch } from 'react-redux'
import { matchSimulationActions } from '../../redux/slices/matchSimulationSlice'
import { Game } from '../../game'
export default (props: any) => {
  const { match, current_user_id, user_id, s3_base_url, arena, runSimulation } =
    props
  const dispatch = useDispatch()
  const isHost = user_id === current_user_id
  const { setSlots, setS3BaseUrl } = matchSimulationActions
  const [gameState, setGameState] = useState({ event: () => {} })
  const {
    title,
    description,
    min_player_frobot,
    max_player_frobot,
    timer,
    slots,
    id,
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

  const sortedSlots = slotInfo.sort((a, b) => a.id - b.id)
  useEffect(() => {
    dispatch(setSlots(sortedSlots))
    const game = new Game([], [], {
      match_id: match.id,
      match_details: match,
      arena,
      s3_base_url,
    })
    game.header()
    if (game !== null) {
      //  const frobots = slots.filter((slot) => slot.frobot !== null)
      // for(let i=0;i<frobots.length ; i++){
      //     game.event({args : [frobots[i].frobot.name,[200,300]], event : 'create_tank'})
      // }
      setGameState(game)
    }
  }, [])
  useEffect(() => {
    dispatch(setS3BaseUrl(s3_base_url))
  }, [s3_base_url])

  window.addEventListener(`phx:arena_event`, (e) => {
    gameState.event(e.detail)
  })

  return (
    <Box width={'90%'} m={'auto'}>
      <Box my={2}>
        {isHost && (
          <Button variant="contained" onClick={runSimulation}>
            Start Match
          </Button>
        )}
      </Box>
      <Grid container>
        <Grid id="game-arena" item md={12} lg={9}></Grid>
        <Grid item md={12} lg={3}></Grid>
      </Grid>
      {/* <Grid container spacing={2}>
          <Grid
            item
            md={12}
            lg={6}
            sm={12}
          >
            <FrobotsListContainer isHost={isHost} />
          </Grid>
          <Grid item md={12} lg={6} sm={12} xs={12}>
            <FrobotDetailsPreview isHost={isHost} updateSlot={undefined} />
          </Grid>
        </Grid> */}
    </Box>
  )
}
