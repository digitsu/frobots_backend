import { Box, Button, Card, Grid, Typography } from '@mui/material'
import React, { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createMatchActions } from '../../../redux/slices/createMatch'
import ShowOptionsStepper from './ShowOptionsStepper'
export default () => {
  const { slotOptions, currentActiveSlot, slots } = useSelector(
    (store) => store.createMatch
  )
  const { setCurrentActiveSlot } = createMatchActions
  const dispatch = useDispatch()
  const slotDetails = slots.find(({ id }) => id === currentActiveSlot?.id)
  return (
    <Box sx={{ height: '100%' }}>
      <Box my={2}>
        <Typography variant="subtitle1">Frobot Slot Details</Typography>
      </Box>
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
            slotOptions={slotOptions}
            slotDetails={slotDetails}
          />
        )}
      </Card>
    </Box>
  )
}
