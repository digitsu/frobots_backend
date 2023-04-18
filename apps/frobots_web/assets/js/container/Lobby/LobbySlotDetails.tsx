import { Box, Card, Typography } from '@mui/material'
import React from 'react'
import { useSelector } from 'react-redux'
import ShowOptionsStepper from './ShowOptionsStepper'
export default ({ updateSlot, isHost }) => {
  const { slotOptions, currentActiveSlot, slots } = useSelector(
    (store) => store.arenaLobby
  )
  const slotDetails = slots.find(({ id }) => id === currentActiveSlot?.id)
  return (
    <Box sx={{ height: '100%' }}>
      <Card sx={{ height: '100%' }}>
        {currentActiveSlot === null ? (
          <Box position={'relative'} height={'100%'}>
            <Box
              sx={{ filter: 'grayscale(1)' }}
              component={'img'}
              src={'/images/creatematch_bg.png'}
              width={'100%'}
              height={'100%'}
            ></Box>
            <Typography
              variant="h6"
              display={'flex'}
              justifyContent={'center'}
              width={'100%'}
              position={'absolute'}
              top={'50%'}
            >
              Please choose a Slot
            </Typography>
          </Box>
        ) : (
          <ShowOptionsStepper
            key={slotDetails.id}
            slotDetails={slotDetails}
            updateSlot={updateSlot}
            isHost={isHost}
          />
        )}
      </Card>
    </Box>
  )
}
