import React, { useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { useDispatch, useSelector } from 'react-redux'
import HostSlots from './HostSlots'
import ProtobotSlots from './ProtobotSlots'
import { createMatchActions } from '../../../../redux/slices/createMatch'
import ClosedSlot from './ClosedSlot'
import OpenSlot from './OpenSlot'

export default ({ slotDetails, imageBaseUrl }) => {
  const { slotOptions, protobots, userFrobots, currentActiveSlot } =
    useSelector((store) => store.createMatch)
  const { updateSlot } = createMatchActions
  const [currentSlot, setCurrentSlot] = useState({ type: '', url: '' })
  const [currentStep, setCurrentStep] = useState(0)
  const dispatch = useDispatch()

  const slotSelectionHandler = (slot) => {
    if (slot?.type === 'host' || slot?.type === 'proto') {
      setCurrentStep(currentStep + 1)
    } else if (slot?.type === 'open' || slot?.type === 'closed') {
      dispatch(
        updateSlot({
          ...currentActiveSlot,
          type: slot.type,
          label: slot.type === 'open' ? 'Open Slot' : 'Closed Slot',
          name: slot.type === 'open' ? 'Open' : 'Closed',
          url: slot.url,
          slotDetails: slot,
        })
      )
      setCurrentStep(currentStep + 1)
    }
  }

  const SlotItemsConfiguration = () => {
    return (
      <Box sx={{ p: 4, pb: 0 }}>
        <Grid container spacing={3}>
          {slotOptions.map((slot) => (
            <Grid item width={'100%'}>
              <Box
                display={'flex'}
                alignItems={'center'}
                justifyContent={'flex-start'}
                gap={3}
                p={2}
                sx={{
                  cursor: 'pointer',
                  ':hover': {
                    boxShadow: '0 0 0 2pt #00AB55',
                    backgroundColor: `#1C3F3B`,
                  },
                  boxShadow:
                    currentSlot?.slotId === slot.slotId
                      ? '0 0 0 2pt #00AB55'
                      : 'none',
                  backgroundColor:
                    currentSlot?.slotId === slot.slotId
                      ? `#1C3F3B`
                      : 'transparent',
                }}
                onClick={() => {
                  slotSelectionHandler(slot)
                  setCurrentSlot(slot)
                }}
              >
                <Box component={'img'} src={slot.url} />
                <Box>
                  <Typography variant="subtitle1">{slot.label}</Typography>
                  <Typography variant="caption">{slot.content}</Typography>
                </Box>
              </Box>
            </Grid>
          ))}
        </Grid>
      </Box>
    )
  }

  return (
    <>
      {currentStep === 0 && <SlotItemsConfiguration />}
      {currentSlot?.type === 'host' && (
        <HostSlots
          userFrobots={userFrobots}
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          imageBaseUrl={imageBaseUrl}
        />
      )}
      {currentSlot?.type === 'proto' && (
        <ProtobotSlots
          protobots={protobots}
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          imageBaseUrl={imageBaseUrl}
        />
      )}
      {currentSlot?.type === 'closed' && (
        <ClosedSlot
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
        />
      )}
      {currentSlot?.type === 'open' && (
        <OpenSlot
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
        />
      )}
    </>
  )
}
