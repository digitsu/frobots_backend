import { Grid, Box, Button } from '@mui/material'
import moment from 'moment'
import React from 'react'
import { useSelector } from 'react-redux'
import SlotContainer from './SlotContainer'
import SlotDetails from './SlotDetails'

export default ({ createMatch, imageBaseUrl }) => {
  const {
    matchTitle: title,
    matchDescription: description,
    matchTime: match_time,
    countDownTimer: timer,
    minFrobots: min_player_frobot,
    maxFrobots: max_player_frobot,
    slots: storeSlots,
    mapSelected,
  } = useSelector((store) => store.createMatch)
  const launchMatch = () => {
    const slots = storeSlots.map((slot) => {
      if (
        slot.type?.toLowerCase() === 'open' ||
        slot.type?.toLowerCase() === 'closed'
      ) {
        return { status: slot.type }
      } else {
        return {
          status: 'ready',
          frobot_id: slot.slotDetails?.id,
          slot_type: slot.type === 'proto' ? 'protobot' : 'host',
        }
      }
    })
    createMatch({
      title,
      description,
      match_time: moment(match_time).utc().format('YYYY-MM-DDTHH:mm:ss.SSS[Z]'),
      timer,
      arena_id: mapSelected?.id,
      min_player_frobot,
      max_player_frobot,
      slots,
      type: 'real',
    })
  }
  const isAllSlotsClosed = storeSlots.every((slot) => slot?.type === 'closed')

  return (
    <Box my={2}>
      <Grid
        container
        spacing={2}
        alignSelf={'stretch'}
        sx={{ width: '90%', m: 'auto' }}
      >
        <Grid item md={12} lg={6}>
          <SlotContainer />
        </Grid>
        <Grid item md={12} lg={6}>
          <SlotDetails imageBaseUrl={imageBaseUrl} />
        </Grid>
        <Grid item md={12} mb={4}>
          <Box
            display={'flex'}
            alignItems={'center'}
            justifyContent={'flex-end'}
            mt={10}
          >
            <Button
              disabled={isAllSlotsClosed}
              sx={{ px: 5, py: 1 }}
              variant="contained"
              onClick={launchMatch}
            >
              Launch
            </Button>
          </Box>
        </Grid>
      </Grid>
    </Box>
  )
}
