import React, { useEffect, useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { useDispatch, useSelector } from 'react-redux'
import HostSlots from './HostSlots'
import ProtobotSlots from './ProtobotSlots'
import { arenaLobbyActions } from '../../../redux/slices/arenaLobbySlice'
import ClosedSlot from './ClosedSlot'
import OpenSlot from './OpenSlot'

export default ({ slotDetails, updateSlot, isHost, setShowOptions }) => {
  const {
    slotOptions,
    protobots,
    userFrobots,
    currentActiveSlot,
    slots: storeSlots,
  } = useSelector((store) => store.arenaLobby)
  const { updateSlot: updateSlotStore } = arenaLobbyActions
  const [currentSlot, setCurrentSlot] = useState({
    type: '',
    url: '',
    id: null,
  })
  const [currentStep, setCurrentStep] = useState(0)
  const dispatch = useDispatch()
  const slotSelectionHandler = () => {
    if (currentSlot?.type === 'host' || currentSlot?.type === 'proto') {
      setCurrentStep(currentStep + 1)
    } else if (currentSlot?.type === 'open' || currentSlot?.type === 'closed') {
      dispatch(
        updateSlotStore({
          ...currentActiveSlot,
          type: currentSlot.type,
          label: currentSlot.type === 'open' ? 'Open Slot' : 'Closed Slot',
          name: currentSlot.type === 'open' ? 'Open' : 'Closed',
          url: currentSlot.url,
          slotDetails: currentSlot,
        })
      )
      setCurrentStep(currentStep + 1)
      updateSlot({
        type: currentSlot?.type,
        payload: {
          slot_id: currentActiveSlot?.id,
          status: currentSlot?.type,
          slot_type: null,
          frobot_id: null,
        },
      })
    }
  }

  const SlotOption = ({ slot }) => {
    return (
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
              currentSlot?.slotId === slot.slotId ? `#1C3F3B` : 'transparent',
          }}
          onClick={() => setCurrentSlot(slot)}
        >
          <Box component={'img'} src={slot.url} />
          <Box>
            <Typography variant="subtitle1">{slot.label}</Typography>
            <Typography variant="caption">{slot.content}</Typography>
          </Box>
        </Box>
      </Grid>
    )
  }

  const SlotItemsConfiguration = ({ isHost }) => {
    return (
      <Box sx={{ p: 4, pb: 0 }}>
        <Grid container spacing={3}>
          {slotOptions.map((slot) => (
            <SlotOption slot={slot} />
          ))}
        </Grid>
        <Box
          textAlign={'center'}
          mt={4}
          width={'100%'}
          display={'flex'}
          flexDirection={'column'}
        >
          <Button
            sx={{ mb: 1 }}
            fullWidth
            variant="outlined"
            onClick={() => setShowOptions(false)}
          >
            Back
          </Button>
          <Button fullWidth variant="contained" onClick={slotSelectionHandler}>
            Select And Continue
          </Button>
        </Box>
      </Box>
    )
  }

  useEffect(() => {
    if (!isHost) {
      setCurrentStep(1)
    }
  }, [])

  return (
    <>
      {currentStep === 0 && isHost && (
        <SlotItemsConfiguration isHost={isHost} />
      )}
      {(currentStep === 1 || currentStep === 2) && !isHost && (
        <HostSlots
          userFrobots={userFrobots}
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          updateSlot={updateSlot}
          isHost={isHost}
          setShowOptions={setShowOptions}
        />
      )}
      {currentSlot?.type === 'host' && (
        <HostSlots
          userFrobots={userFrobots}
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          updateSlot={updateSlot}
          isHost={isHost}
          setShowOptions={setShowOptions}
        />
      )}
      {currentSlot?.type === 'proto' && (
        <ProtobotSlots
          protobots={protobots}
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          updateSlot={updateSlot}
          setShowOptions={setShowOptions}
        />
      )}
      {currentSlot?.type === 'closed' && (
        <ClosedSlot
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          slotDetails={slotDetails}
          isHost={isHost}
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
