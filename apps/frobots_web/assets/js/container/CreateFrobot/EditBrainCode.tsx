import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Box, Tab, Tabs, Button, Grid, Tooltip } from '@mui/material'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import LuaEditor from '../Garage/LuaEditor'
import { createFrobotActions } from '../../redux/slices/createFrobot'
import Popup from '../../components/Popup'
import { CreateFrobotBrainCodeCopyPromptDescription } from '../../mock/texts'
import CompareArrowsIcon from '@mui/icons-material/CompareArrows'

export default () => {
  const { brainCode, blocklyCode: blocklyCodeStore } = useSelector(
    (store: any) => store.createFrobot
  )
  const [luaCode, setLuaCode] = useState('')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState('')
  const [showCopyPrompt, setShowCopyPrompt] = useState(false)
  const [blocklyLuaCode, setBlocklyLuaCode] = useState(
    brainCode?.brain_code || ''
  )
  const { setBlocklyCode: setBlocklyCodeHandler, setBrainCode } =
    createFrobotActions
  const dispatch = useDispatch()
  function a11yProps(index: number) {
    return {
      id: `simple-tab-${index}`,
      'aria-controls': `simple-tabpanel-${index}`,
    }
  }

  const [tabIndex, setTabIndex] = React.useState(0)

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
  return (
    <Box mt={5}>
      <>
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
                    label="Blockly Editor"
                    {...a11yProps(0)}
                  />
                  <Tab
                    sx={{ color: '#fff' }}
                    label="Brain Code"
                    {...a11yProps(1)}
                  />
                </Tabs>
              </Box>
              <Box>
                {tabIndex === 0 && (
                  <>
                    <Tooltip title={'Transfer Brain Code'}>
                      <Button
                        onClick={() => setShowCopyPrompt(true)}
                        variant="contained"
                        color="inherit"
                      >
                        <CompareArrowsIcon />
                      </Button>
                    </Tooltip>
                    <Popup
                      open={showCopyPrompt}
                      cancelAction={() => setShowCopyPrompt(false)}
                      successAction={handleCopyConfirm}
                      successLabel={'Confirm'}
                      cancelLabel={'Cancel'}
                      label={''}
                      description={CreateFrobotBrainCodeCopyPromptDescription}
                    />
                  </>
                )}
              </Box>
            </Box>
          </Box>
          {
            <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
              <Grid container>
                <Grid item xs={12} sm={12} md={6} lg={6} xl={6}>
                  <BlocklyEditor
                    defaultXml={blocklyCodeStore}
                    setXmlText={setXmlText}
                    workspaceDidChange={workspaceDidChange}
                  />
                </Grid>
                <Grid item xs={12} sm={12} md={6} lg={6} xl={6}>
                  <LuaEditor luaCode={luaCode} onEditorChange={() => {}} />
                </Grid>
              </Grid>
            </Box>
          }
          {
            <Box sx={{ p: 3 }} display={tabIndex === 1 ? 'block' : 'none'}>
              <LuaEditor
                luaCode={blocklyLuaCode}
                onEditorChange={onEditorChange}
              />
            </Box>
          }
        </Box>
      </>
    </Box>
  )
}
