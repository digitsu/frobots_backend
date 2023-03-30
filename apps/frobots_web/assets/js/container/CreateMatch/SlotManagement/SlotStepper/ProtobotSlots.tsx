import React, { useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { createMatchActions } from '../../../../redux/slices/createMatch'
import { useDispatch, useSelector } from 'react-redux'
export default ({ protobots, currentStep, setCurrentStep, slotDetails }) => {
  const { updateSlot } = createMatchActions
  const { currentActiveSlot } = useSelector((store) => store.createMatch)
  const dispatch = useDispatch()
  const [currentSlot, setCurrentSlot] = useState(null)

  const deployProtobot = () => {
    dispatch(
      updateSlot({
        ...currentActiveSlot,
        type: 'proto',
        name: currentSlot.name,
        url: '/images/yellow_frobot.svg',
        slotDetails: currentSlot,
      })
    )
    setCurrentStep(currentStep + 1)
  }
  return (
    <>
      {currentStep === 1 && (
        <Box
          sx={{
            p: 3,
            pb: 1,
            height: '100%',
            maxHeight: 490,
            overflowY: 'scroll',
          }}
        >
          <Grid container spacing={3}>
            {protobots.map((slot) => (
              <Grid item width={'100%'}>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'flex-start'}
                  gap={3}
                  p={1}
                  sx={{
                    cursor: 'pointer',
                    ':hover': {
                      boxShadow: '0 0 0 2pt #00AB55',
                      backgroundColor: `#1C3F3B`,
                    },
                    boxShadow:
                      currentSlot?.id === slot.id
                        ? '0 0 0 2pt #00AB55'
                        : 'none',
                    backgroundColor:
                      currentSlot?.id === slot.id ? `#1C3F3B` : 'transparent',
                  }}
                  onClick={() => setCurrentSlot(slot)}
                >
                  <Box component={'img'} src={slot.avatar} />
                  <Box>
                    <Typography variant="subtitle1">{slot.name}</Typography>
                    <Typography variant="caption">{slot.bio}</Typography>
                  </Box>
                </Box>
              </Grid>
            ))}
            <Box
              sx={{
                position: 'absolute',
                left: '50%',
                px: 4,
                transform: 'translate(-50%, -50%)',
                width: '100%',
                bottom: 0,
              }}
            >
              <Button
                fullWidth
                variant="outlined"
                onClick={() => setCurrentStep(currentStep - 1)}
              >
                Back
              </Button>
              <Box mt={1}>
                {' '}
                <Button fullWidth variant="contained" onClick={deployProtobot}>
                  Deploy Protobot
                </Button>
              </Box>
            </Box>
          </Grid>
        </Box>
      )}

      {currentStep === 2 && (
        <Box p={2} position={'relative'} height={'100%'}>
          <Box
            component={'img'}
            src={slotDetails.slotDetails?.avatar}
            width={'70%'}
            m={'auto'}
          />
          <Box mx={2} my={1}>
            <Typography variant="h6">
              {slotDetails.slotDetails?.name}
            </Typography>
            <Box my={1} maxHeight={120} overflow={'scroll'}>
              <Typography>{slotDetails.slotDetails?.bio}</Typography>
            </Box>
          </Box>
          <Box
            sx={{
              position: 'absolute',
              left: '50%',
              px: 4,
              transform: 'translate(-50%, -50%)',
              width: '100%',
              bottom: 0,
            }}
          >
            <Button
              fullWidth
              variant="outlined"
              onClick={() => setCurrentStep(0)}
            >
              Modify
            </Button>
          </Box>
        </Box>
      )}
    </>
  )
}
