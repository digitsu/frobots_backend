import {
  Box,
  Button,
  Container,
  Stack,
  Step,
  StepLabel,
  Stepper,
} from '@mui/material'
import React, { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'
import ChooseArena from '../../CreateMatch/ChooseArena'
import CreateTournamentDetails from './CreateTournamentDetails'
import TournamentPreview from './TournamentPreview'
export default (props) => {
  const { arenas, s3_base_url, createTournament, tournament_initial_name } =
    props
  const { activeStep, mapSelected, name } = useSelector(
    (store: any) => store.createTournament
  )
  const dispatch = useDispatch()
  const { incrementStep, decrementStep, setMap, setTournamentName } =
    createTournamentActions
  const CustomStepIcon = ({ active, icon }) => {
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
    {
      label: 'Tournament Details',
      component: (
        <CreateTournamentDetails
          tournament_initial_name={tournament_initial_name}
        />
      ),
    },
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

  useEffect(() => {
    if (!name) {
      dispatch(setTournamentName(tournament_initial_name))
    }
  }, [])

  return (
    <Box width={'90%'} m={'auto'}>
      <Box display={'flex'} alignItems={'center'} justifyContent={'center'}>
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
      </Box>
      {steps.map(({ component }, index) => index === activeStep && component)}
      <Box
        display={'flex'}
        alignItems={'center'}
        justifyContent={'center'}
        width={'60%'}
        m={'auto'}
        pb={4}
        mt={activeStep === 1 && 6}
      >
        <Container sx={{ maxWidth: 1440, p: '0 !important', m: 0 }}>
          <Stack
            direction={'column-reverse'}
            justifyContent={'flex-end'}
            gap={2}
          >
            <Box>
              <Button
                fullWidth
                onClick={() => dispatch(decrementStep())}
                variant="outlined"
                sx={{
                  px: 5,
                  py: 1.5,
                  visibility: activeStep > 0 ? 'visible' : 'hidden',
                }}
              >
                Back
              </Button>
            </Box>
            <Box>
              <Button
                fullWidth
                onClick={() => dispatch(incrementStep())}
                variant="contained"
                disabled={activeStep === 1 && mapSelected === null}
                sx={{
                  px: 5,
                  py: 1.5,
                  display:
                    activeStep < steps.length &&
                    activeStep !== 0 &&
                    activeStep !== steps.length - 1
                      ? 'block'
                      : 'none',
                }}
              >
                Next
              </Button>
            </Box>
          </Stack>
        </Container>
      </Box>
    </Box>
  )
}
