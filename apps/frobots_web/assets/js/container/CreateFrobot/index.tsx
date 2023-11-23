import React, { useState } from 'react'
import { Stepper, Step, Box, StepLabel, Button } from '@mui/material'
import { useSelector, useDispatch } from 'react-redux'
import { createFrobotActions } from '../../redux/slices/createFrobot'
import BasicDetailsForm from './BasicDetailsForm'
import EditBrainCode from './EditBrainCode'
import PreviewFrobot from './PreviewFrobot'
import Popup from '../../components/Popup'
import { BackButtonWorkspacePromptDescription } from '../../mock/texts'
import Blockly from 'blockly'

export default (props: any) => {
  const { templates, createFrobot, starterMechs, s3_base_url } = props
  const [showBackButtonPrompt, setShowBackButtonPrompt] = useState(false)
  const dispatch = useDispatch()
  const { activeStep, brainCode, isTutorialFlow, selectedProtobot } =
    useSelector((store: any) => store.createFrobot)
  const { incrementStep, decrementStep, setTutorialFlow } = createFrobotActions
  const steps = [
    {
      label: 'Step 1',
      component: (
        <BasicDetailsForm
          templates={templates}
          starterMechs={
            starterMechs.length
              ? starterMechs
              : [{ id: 0, avatar: '', pixellated_img: '' }]
          }
          s3BaseUrl={s3_base_url}
        />
      ),
    },
    { label: 'Step 2', component: <EditBrainCode templates={templates} /> },
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

  const backButtonHandler = () => {
    if (activeStep === 1) {
      if (!isTutorialFlow) {
        dispatch(decrementStep())
      } else {
        setShowBackButtonPrompt(true)
      }
    } else {
      dispatch(decrementStep())
    }
  }

  const resetTutorial = () => {
    const parser = new DOMParser()
    const workspace = Blockly.getMainWorkspace()
    const currentProtobot =
      templates.find(({ name }) => name === selectedProtobot?.label) || null
    const xmlDom = parser.parseFromString(
      currentProtobot?.blockly_code,
      'text/xml'
    )
    Blockly.Xml.clearWorkspaceAndLoadFromXml(xmlDom.documentElement, workspace)
    setShowBackButtonPrompt(false)
    dispatch(setTutorialFlow(false))
  }

  const handleBackPromptConfirm = () => {
    dispatch(decrementStep())
    resetTutorial()
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
              onClick={backButtonHandler}
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
              disabled={activeStep === 1 && brainCode?.brain_code?.length === 0}
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
        <Popup
          open={showBackButtonPrompt}
          cancelAction={() => setShowBackButtonPrompt(false)}
          successAction={handleBackPromptConfirm}
          successLabel={'Confirm'}
          cancelLabel={'Cancel'}
          label={'Warning'}
          description={BackButtonWorkspacePromptDescription}
        />
      </Box>
      {steps.map(({ component }, index) => index === activeStep && component)}
    </>
  )
}
