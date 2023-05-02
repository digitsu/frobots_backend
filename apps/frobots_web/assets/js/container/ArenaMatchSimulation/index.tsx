import React, { useEffect } from 'react'
import { Box, Grid, Typography, Card } from '@mui/material'
import FrobotsListContainer from './FrobotsListContainer'
import FrobotDetailsPreview from './FrobotDetailsPreview'
import { useDispatch } from 'react-redux'
import { matchSimulationActions } from '../../redux/slices/matchSimulationSlice'

export default (props: any) => {
  const { match, current_user_id, user_id, s3_base_url, runSimulation } = props
  const dispatch = useDispatch()
  const isHost = user_id === current_user_id
  const { setSlots, setS3BaseUrl } = matchSimulationActions

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
  }, [])
  useEffect(() => {
    dispatch(setS3BaseUrl(s3_base_url))
  }, [s3_base_url])

  useEffect(() => {
    // runSimulation()
    console.log('REfresheddd .......')
  }, [])

  return (
      <Box width={'90%'} m={'auto'}>
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
