import React, { useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { createMatchActions } from '../../../../redux/slices/createMatch'
import { useDispatch, useSelector } from 'react-redux'

export default ({
  userFrobots,
  currentStep,
  setCurrentStep,
  slotDetails,
  imageBaseUrl,
}) => {
  const { updateSlot } = createMatchActions
  const { currentActiveSlot } = useSelector((store: any) => store.createMatch)
  const dispatch = useDispatch()
  const [currentSlot, setCurrentSlot] = useState(null)

  const deployFrobot = () => {
    dispatch(
      updateSlot({
        ...currentActiveSlot,
        type: 'host',
        name: currentSlot?.name,
        url: '/images/red_frobot.svg',
        slotDetails: currentSlot,
      })
    )
    setCurrentStep(currentStep + 1)
  }

  return (
    <>
      {currentStep === 1 && (
        <Box sx={{ p: 3, pb: 1, maxHeight: 490, overflowY: 'scroll' }}>
          <Grid container spacing={3}>
            {userFrobots.map((slot: any) => (
              <Grid item width={'100%'} key={slot.id}>
                <Box
                  display={'flex'}
                  alignItems={'left'}
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
                  <Box position={'relative'} width={'30%'} m={'auto'}>
                    <Box
                      component={'img'}
                      width={'100%'}
                      src={'/images/frobot_bg.png'}
                    />
                    <Box
                      sx={{ transform: 'translate(-50%, -50%)' }}
                      top={'50%'}
                      left={'50%'}
                      zIndex={1}
                      position={'absolute'}
                      component={'img'}
                      width={'65%'}
                      height={'65%'}
                      src={`${imageBaseUrl}${slot?.avatar}`}
                    />
                  </Box>
                  <Box width={'70%'}>
                    <Typography variant="subtitle1">{slot.name}</Typography>
                    <Box
                      sx={{
                        height: '120px',
                        overflowY: 'scroll',
                        '&::-webkit-scrollbar': { display: 'none' },
                      }}
                    >
                      <Typography variant="caption" gutterBottom>
                        {slot.bio || '-'}
                      </Typography>
                    </Box>
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
                <Button fullWidth variant="contained" onClick={deployFrobot}>
                  Deploy Frobot
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
