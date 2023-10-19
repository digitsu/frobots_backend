import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import Joyride from 'react-joyride'
import { Box, Tab, Tabs, Button, Grid, Tooltip } from '@mui/material'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import LuaEditor from '../Garage/LuaEditor'
import { createFrobotActions } from '../../redux/slices/createFrobot'
import Popup from '../../components/Popup'
import {
  CreateFrobotBrainCodeCopyPromptDescription,
  ResetWorkspacePopupPromptDescription,
  TutorialPopupPromptDescription,
} from '../../mock/texts'
import HistoryIcon from '@mui/icons-material/History'
import LightbulbIcon from '@mui/icons-material/Lightbulb'
import { handleTourCallback } from '../../utils/util'

export default ({ templates }) => {
  const {
    brainCode,
    blocklyCode: blocklyCodeStore,
    introSteps,
    selectedProtobot,
    isTutorialFlow,
  } = useSelector((store: any) => store.createFrobot)
  const [showTutorial, setShowTutorial] = useState(false)
  const [showTutorialPopup, setShowTutorialPopup] = useState(false)
  const [showResetPopup, setShowResetPopup] = useState(false)
  const [luaCode, setLuaCode] = useState('')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState('')
  const [showCopyPrompt, setShowCopyPrompt] = useState(false)
  const [blocklyLuaCode, setBlocklyLuaCode] = useState(
    brainCode?.brain_code || ''
  )
  const {
    setBlocklyCode: setBlocklyCodeHandler,
    setBrainCode,
    setTutorialFlow,
  } = createFrobotActions
  const currentProtobot =
    templates.find(({ name }) => name === selectedProtobot?.label) || null
  const dispatch = useDispatch()
  function a11yProps(index: number) {
    return {
      id: `simple-tab-${index}`,
      'aria-controls': `simple-tabpanel-${index}`,
    }
  }
  const [tabIndex, setTabIndex] = React.useState(0)
  const workspaceElement = document.getElementById('user-workspace')
  const rect = workspaceElement
    ? workspaceElement.getBoundingClientRect()
    : { top: 0 }
  const distanceFromTop = rect.top + window.scrollY
  const containerMinHeight = `calc(92vh - ${distanceFromTop}px)`

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setTabIndex(newValue)
  }

  useEffect(() => {
    //@ts-ignore
    window.Blockly = Blockly
    customFunctions()
  }, [])

  const workspaceDidChange = (workspace: any) => {
    try {
      const code = luaGenerator.workspaceToCode(workspace)
      if (code != blocklyCode) {
        setBlocklyCode(code)
      }
    } catch (err) {
      console.log(err)
    }
  }

  useEffect(() => {
    setLuaCode(blocklyCode)
  }, [blocklyCode])

  function onEditorChange(code) {
    try {
      dispatch(setBrainCode({ ...brainCode, brain_code: code }))
    } catch (err) {
      console.log(err)
    }
  }

  useEffect(() => {
    dispatch(setBlocklyCodeHandler(xmlText))
  }, [xmlText])

  const handleCopyConfirm = () => {
    setBlocklyLuaCode(blocklyCode)
    setShowCopyPrompt(false)
  }

  const showTutorialHandler = () => {
    Blockly.getMainWorkspace().clear()
    dispatch(setTutorialFlow(true))
    setShowTutorial(true)
    setShowTutorialPopup(false)
  }

  const resetHandler = () => {
    const parser = new DOMParser()
    const workspace = Blockly.getMainWorkspace()
    const xmlDom = parser.parseFromString(
      currentProtobot?.blockly_code,
      'text/xml'
    )
    Blockly.Xml.clearWorkspaceAndLoadFromXml(xmlDom.documentElement, workspace)
    setShowResetPopup(false)
  }

  useEffect(() => {
    if (!isTutorialFlow) {
      resetHandler()
    }
  }, [isTutorialFlow])

  return (
    <>
      <Joyride
        key={`joyride-${showTutorial ? 'active' : 'inactive'}`}
        steps={introSteps}
        run={showTutorial}
        continuous={true}
        showSkipButton={true}
        callback={(data) => handleTourCallback(data, setShowTutorial)}
        showProgress={true}
        disableOverlay
        styles={{
          buttonNext: {
            backgroundColor: '#00AB55',
          },
          buttonBack: {
            color: '#00AB55',
          },
        }}
      />

      <Box mt={5}>
        <Box
          sx={{
            width: '90%',
            backgroundColor: '#323332',
            p: 1,
            m: 'auto',
            mt: 2,
            borderRadius: '10px',
            color: '#fff',
          }}
        >
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <Box
              display={'flex'}
              alignItems={'center'}
              justifyContent={'space-between'}
              width={'100%'}
              px={2.5}
            >
              <Box>
                <Tabs
                  value={tabIndex}
                  onChange={handleChange}
                  textColor={'inherit'}
                  TabIndicatorProps={{
                    sx: {
                      backgroundColor: 'rgb(15 141 77)',
                    },
                  }}
                >
                  <Tab
                    sx={{ color: '#fff' }}
                    label="Block Editor"
                    className="block-editor"
                    {...a11yProps(0)}
                  />
                  <Tab
                    sx={{ color: '#fff' }}
                    label="Brain Code"
                    {...a11yProps(1)}
                  />
                </Tabs>
              </Box>
              <Box display={'flex'} gap={1}>
                {tabIndex === 0 && (
                  <>
                    <Tooltip title={'Sync Brain Code'}>
                      <Button
                        onClick={() => setShowCopyPrompt(true)}
                        variant="contained"
                        color="inherit"
                      >
                        Sync
                      </Button>
                    </Tooltip>
                    <Popup
                      open={showCopyPrompt}
                      cancelAction={() => setShowCopyPrompt(false)}
                      successAction={handleCopyConfirm}
                      successLabel={'Confirm'}
                      cancelLabel={'Cancel'}
                      label={'Warning'}
                      description={CreateFrobotBrainCodeCopyPromptDescription}
                    />
                  </>
                )}
                <>
                  <Button
                    startIcon={<LightbulbIcon />}
                    variant="contained"
                    onClick={() => setShowTutorialPopup(true)}
                  >
                    Tutorial
                  </Button>
                  <Popup
                    open={showTutorialPopup}
                    cancelAction={() => setShowTutorialPopup(false)}
                    successAction={showTutorialHandler}
                    successLabel={'Confirm'}
                    cancelLabel={'Cancel'}
                    label={'Warning'}
                    description={TutorialPopupPromptDescription}
                  />
                </>
                <>
                  <Button
                    startIcon={<HistoryIcon />}
                    variant="outlined"
                    onClick={() => setShowResetPopup(true)}
                  >
                    Reset
                  </Button>
                  <Popup
                    open={showResetPopup}
                    cancelAction={() => setShowResetPopup(false)}
                    successAction={resetHandler}
                    successLabel={'Confirm'}
                    cancelLabel={'Cancel'}
                    label={'Warning'}
                    description={ResetWorkspacePopupPromptDescription}
                  />
                </>
              </Box>
            </Box>
          </Box>
          <Box id={'user-workspace'}>
            {
              <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
                <Grid container minHeight={containerMinHeight}>
                  <Grid item xs={12} sm={12} md={8} lg={8} xl={8}>
                    <BlocklyEditor
                      defaultXml={blocklyCodeStore}
                      setXmlText={setXmlText}
                      workspaceDidChange={workspaceDidChange}
                    />
                  </Grid>
                  <Grid item xs={12} sm={12} md={4} lg={4} xl={4}>
                    <LuaEditor luaCode={luaCode} onEditorChange={() => {}} />
                  </Grid>
                </Grid>
              </Box>
            }
            {
              <Box sx={{ p: 3 }} display={tabIndex === 1 ? 'block' : 'none'}>
                <Grid container minHeight={containerMinHeight}>
                  <Grid item width={'100%'}>
                    <LuaEditor
                      luaCode={blocklyLuaCode}
                      onEditorChange={onEditorChange}
                    />
                  </Grid>
                </Grid>
              </Box>
            }
          </Box>
        </Box>
      </Box>
    </>
  )
}
