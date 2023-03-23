import React from 'react'
import { Stepper, Step, Box, StepLabel, Button } from '@mui/material'
import { useSelector, useDispatch } from 'react-redux'
import { createMatchActions } from '../../redux/slices/createMatch'
import CreateMatchDetails from './CreateMatchDetails'
import ChooseArena from './ChooseArena'
import SlotManagement from './SlotManagement'
export default (props: any) => {
  const { templates } = props
  const dispatch = useDispatch()
  const { activeStep } = useSelector((store: any) => store.createMatch)
  const { incrementStep, decrementStep } = createMatchActions
  const steps = [
    { label: 'Step 1', component: <CreateMatchDetails /> },
    { label: 'Step 2', component: <ChooseArena /> },
    { label: 'Step 3', component: <SlotManagement /> },
  ]

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

  return (
    <>
      {' '}
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
          <Box width={'60%'} m={'auto'}>
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
      </Box>
      {steps.map(({ component }, index) => index === activeStep && component)}
    </>
  )
}