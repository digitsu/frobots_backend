import { Box, Button, Container, Step, StepLabel, Stepper } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'
import ChooseArena from '../../CreateMatch/ChooseArena'
import CreateTournamentDetails from './CreateTournamentDetails'
import TournamentPreview from './TournamentPreview'
export default (props) => {
  const { arenas, s3_base_url, createTournament } = props
  const { activeStep, mapSelected } = useSelector(
    (store: any) => store.createTournament
  )
  const dispatch = useDispatch()

  const { incrementStep, decrementStep, setMap } = createTournamentActions
  const CustomStepIcon = ({ active, completed, icon }) => {
    return (
      <Box
        sx={{
          width: 24,
          height: 24,
          borderRadius: '50%',
          backgroundColor: active ? '#4caf50' : '#637381',
          color: '#fff',
          textAlign: 'center',
        }}
      >
        {icon}
      </Box>
    )
  }
  const steps = [
    { label: 'Tournament Details', component: <CreateTournamentDetails /> },
    {
      label: 'Arena Selection',
      component: (
        <ChooseArena
          arenas={arenas}
          s3_base_url={s3_base_url}
          setMap={setMap}
          mapSelected={mapSelected}
        />
      ),
    },
    {
      label: 'Preview Details',
      component: (
        <TournamentPreview
          s3_base_url={s3_base_url}
          createTournament={createTournament}
        />
      ),
    },
  ]
  return (
    <Box width={'90%'} m={'auto'}>
      <Box
        display={'flex'}
        alignItems={'center'}
        justifyContent={'space-between'}
      >
        <Box>
          <Button
            onClick={() => dispatch(decrementStep())}
            variant="outlined"
            sx={{
              px: 5,
              py: 1,
              visibility: activeStep > 0 ? 'visible' : 'hidden',
            }}
          >
            Back
          </Button>
        </Box>
        <Container sx={{ maxWidth: 1440, p: '0 !important', m: 0 }}>
          <Box>
            <Stepper
              alternativeLabel
              activeStep={activeStep}
              sx={{
                '& .MuiStepLabel-root': { color: '#fff !important' },
                '& .MuiStepLabel-label': { color: '#fff !important' },
                '& .MuiStepConnector-line': { borderColor: 'rgb(31 41 55 /1)' },
              }}
            >
              {steps.map((item, index) => (
                <Step>
                  <StepLabel
                    StepIconComponent={(props) => (
                      <CustomStepIcon {...props} icon={index + 1} />
                    )}
                    StepIconProps={{
                      style: {
                        color: activeStep === index ? 'green' : 'grey',
                      },
                    }}
                  >
                    {item.label}
                  </StepLabel>
                </Step>
              ))}
            </Stepper>
          </Box>
        </Container>
        <Box>
          <Button
            onClick={() => dispatch(incrementStep())}
            variant="contained"
            sx={{
              px: 5,
              py: 1,
              visibility:
                activeStep < steps.length &&
                activeStep !== 0 &&
                activeStep !== steps.length - 1
                  ? 'visible'
                  : 'hidden',
            }}
          >
            Next
          </Button>
        </Box>
      </Box>
      {steps.map(({ component }, index) => index === activeStep && component)}
    </Box>
  )
}
