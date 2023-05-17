import React, { useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { createMatchActions } from '../../../../redux/slices/createMatch'
import { useDispatch, useSelector } from 'react-redux'

export default ({
  protobots,
  currentStep,
  setCurrentStep,
  slotDetails,
  imageBaseUrl,
}) => {
  const { updateSlot } = createMatchActions
  const { currentActiveSlot } = useSelector((store) => store.createMatch)
  const dispatch = useDispatch()
  const [currentSlot, setCurrentSlot] = useState(null)

  const deployProtobot = () => {
    dispatch(
      updateSlot({
        ...currentActiveSlot,
        type: 'proto',
        name: `NPC: ${currentSlot.name}`,
        url: `${imageBaseUrl}${currentSlot.avatar}`,
        slotDetails: currentSlot,
      })
    )
    setCurrentStep(currentStep + 1)
  }

  return (
    <>
      {currentStep === 1 && (
        <Box sx={{ height: 620 }}>
          <Box
            sx={{
              p: 3,
              pb: 1,
              height: '100%',
              maxHeight: 490,
              overflowY: 'scroll',
            }}
          >
            <Box>
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
                          currentSlot?.id === slot.id
                            ? `#1C3F3B`
                            : 'transparent',
                      }}
                      onClick={() => setCurrentSlot(slot)}
                    >
                      <Box position={'relative'}>
                        <Box
                          component={'img'}
                          width={70}
                          src={'/images/frobot_bg.png'}
                        />
                        <Box
                          component={'img'}
                          src={`${imageBaseUrl}${slot.avatar}`}
                          width={'75%'}
                          position={'absolute'}
                          top={'50%'}
                          left={'50%'}
                          sx={{ transform: 'translate(-50%,-50%)' }}
                        />
                      </Box>
                      <Box flex={6}>
                        <Typography variant="subtitle1">{slot.name}</Typography>
                        <Typography variant="caption">{slot.bio}</Typography>
                      </Box>
                    </Box>
                  </Grid>
                ))}
              </Grid>
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
                onClick={() => setCurrentStep(currentStep - 1)}
              >
                Back
              </Button>
              <Box mt={1}>
                {' '}
                <Button
                  fullWidth
                  disabled={currentSlot === null || protobots.length === 0}
                  variant="contained"
                  onClick={deployProtobot}
                >
                  Deploy Protobot
                </Button>
              </Box>
            </Box>
          </Box>
        </Box>
      )}

      {currentStep === 2 && (
        <Box p={2} position={'relative'} height={'100%'}>
          <Box
            component={'img'}
            src={`${imageBaseUrl}${slotDetails.slotDetails?.avatar}`}
            width={'60%'}
            m={'auto'}
          />
          <Box mx={2} my={1}>
            <Typography variant="h6">
              {slotDetails.slotDetails?.name}
            </Typography>
            <Box
              my={1}
              sx={{
                maxHeight: '45px',
                overflowY: 'scroll',
                '&::-webkit-scrollbar': { display: 'none' },
              }}
            >
              <Typography variant="caption">
                {slotDetails.slotDetails?.bio}
              </Typography>
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
              variant="contained"
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
