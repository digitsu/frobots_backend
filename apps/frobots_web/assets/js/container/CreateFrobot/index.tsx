import React from 'react'
import { Stepper, Step, Box, StepLabel, Button } from '@mui/material'
import { useSelector, useDispatch } from 'react-redux'
import { createFrobotActions } from '../../redux/slices/createFrobot'
import BasicDetailsForm from './BasicDetailsForm'
import EditBrainCode from './EditBrainCode'
import PreviewFrobot from './PreviewFrobot'

export default (props: any) => {
  const { templates, createFrobot, starterMechs, s3_base_url } = props
  const dispatch = useDispatch()
  const { activeStep, brainCode } = useSelector(
    (store: any) => store.createFrobot
  )
  const { incrementStep, decrementStep } = createFrobotActions
  const steps = [
    {
      label: 'Step 1',
      component: (
        <BasicDetailsForm
          templates={templates}
          starterMechs={starterMechs}
          s3BaseUrl={s3_base_url}
        />
      ),
    },
    { label: 'Step 2', component: <EditBrainCode /> },
    {
      label: 'Step 3',
      component: (
        <PreviewFrobot createFrobot={createFrobot} s3BaseUrl={s3_base_url} />
      ),
    },
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
                <Step key={index}>
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
              disabled={activeStep === 1 && brainCode?.brain_code.length === 0}
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
