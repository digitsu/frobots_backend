import { Grid, Box, Button } from '@mui/material'
import React, { useEffect } from 'react'
import LobbyDetails from './LobbyDetails'
import LobbySlotContainer from './LobbySlotContainer'
import LobbySlotDetails from './LobbySlotDetails'
import { arenaLobbyActions } from '../../redux/slices/arenaLobbySlice'
import { useDispatch } from 'react-redux'
export default (props) => {
  const {
    match,
    templates,
    frobots,
    updateSlot,
    current_user_id,
    s3_base_url,
    user_id,
  } = props
  const dispatch = useDispatch()
  const isHost = user_id === current_user_id
  const { setSlots, setProtobots, setUserFrobots, setS3BaseUrl } =
    arenaLobbyActions
  const {
    title,
    description,
    min_player_frobot,
    max_player_frobot,
    timer,
    slots,
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
    dispatch(setProtobots(templates))
    dispatch(setUserFrobots(frobots))
    dispatch(setS3BaseUrl(s3_base_url))
  }, [templates, frobots, s3_base_url])
  return (
    <Box width={'90%'} m={'auto'}>
      <Grid container spacing={2}>
        <Grid md={12} width={'100%'}>
          <Box
            mt={4}
            display={'flex'}
            alignItems={'center'}
            justifyContent={'flex-end'}
          >
            <Button sx={{ px: 3 }} variant="contained">
              {isHost ? 'Start Match' : 'Join'}
            </Button>
          </Box>
        </Grid>
        <Grid item md={12} lg={12} sm={12}>
          <LobbyDetails
            title={title}
            description={description}
            min_player_frobot={min_player_frobot}
            max_player_frobot={max_player_frobot}
            timer={timer}
          />
        </Grid>
        <Grid item md={12} lg={6} sm={12}>
          <LobbySlotContainer isHost={isHost} />
        </Grid>
        <Grid item md={12} lg={6} sm={12} xs={12}>
          <LobbySlotDetails updateSlot={updateSlot} isHost={isHost} />
        </Grid>
      </Grid>
    </Box>
  )
}
