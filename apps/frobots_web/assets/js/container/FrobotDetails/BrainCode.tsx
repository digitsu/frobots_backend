import React, { useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import { Box, Tab, Tabs, Button, Autocomplete, TextField } from '@mui/material'
import LuaEditor from '../Garage/LuaEditor'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const {
    frobot,
    updateFrobotCode,
    requestMatch,
    runSimulation,
    cancelSimulation,
    changeProtobot,
    templates,
  } = props
  const [isEditable, enableEdit] = useState(false)
  const [luaCode, setLuaCode] = useState(frobot.brain_code || '')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(
    frobot.blockly_code || BlankBlocklyCode
  )
  const [isSelectedProtobot, setIsSelectedProtobot] = useState(false)
  const [isRequestedMatch, setIsRequestedMatch] = useState(false)
  const [isSimulationStarted, setIsSimulationStarted] = useState(false)

  const templateFrobots =
    templates?.map(({ name}, index) => ({
      label: name,
      id: name,
    })) || []

  function a11yProps(index: number) {
    return {
      id: `simple-tab-${index}`,
      'aria-controls': `simple-tabpanel-${index}`,
    }
  }

  const [tabIndex, setTabIndex] = React.useState(0)

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    enableEdit(true)
    setTabIndex(newValue)
  }

  useEffect(() => {
    //@ts-ignore
    window.Blockly = Blockly
    customFunctions()
  }, [])

  function onEditorChange(code: string) {
    try {
      setLuaCode(code)
    } catch (err) {
      console.log(err)
    }
  }

  const workspaceDidChange = (workspace: any) => {
    try {
      const code = luaGenerator.workspaceToCode(workspace)
      if (code != blocklyCode) {
        setBlocklyCode(code)

        if (isEditable) {
          setLuaCode(code)
        }
      }
    } catch (err) {
      console.log(err)
    }
  }

  const saveConfig = () => {
    if (!luaCode || luaCode.trim() === '') {
      return alert("Frobot can't be updated with empty lua code")
    }

    const requestBody = {
      frobot_id: frobot.frobot_id,
      blockly_code: xmlText,
      brain_code: luaCode,
    }

    updateFrobotCode(requestBody)
  }

  const handleRequestMatch = () => {
    if (!luaCode || luaCode.trim() === '') {
      return alert("Match can't be requested with empty lua code")
    } else {
      requestMatch()
      setIsRequestedMatch(true)
    }
  }

  const handleRunSimulation = () => {
    if (!luaCode || luaCode.trim() === '') {
      return alert("Simulation can't be started with empty lua code")
    } else {
      runSimulation(frobot)
      setIsSimulationStarted(true)
    }
  }

  const handleCancelSimulation = () => {
    cancelSimulation()
    setIsRequestedMatch(false)
    setIsSimulationStarted(false)
    setIsSelectedProtobot(false)
  }

  const handleChangeOpponent = (event, option) => {
    if (option.id) {
      changeProtobot(option.id)
      setIsSelectedProtobot(true)
    }
  }

  return !isRequestedMatch ? (
    <Box mt={8}>
      <>
        <Box
          sx={{
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
                    label="Lua Code"
                    {...a11yProps(1)}
                  />
                </Tabs>
              </Box>
              <Box display={'flex'}>
                <Button
                  variant="outlined"
                  color="inherit"
                  size="small"
                  onClick={saveConfig}
                >
                  Save
                </Button>{' '}
                <Autocomplete
                  sx={{
                    pl: 1,
                    pr: 1,
                    width: 200,
                  }}
                  onChange={handleChangeOpponent}
                  options={templateFrobots}
                  renderInput={(params) => (
                    <TextField
                      {...params}
                      label="Select an opponent"
                      variant="outlined"
                      size="small"
                      name="list-opponent"
                    />
                  )}
                />
                {''}
                {isSelectedProtobot && (
                  <Button
                    variant="outlined"
                    color="inherit"
                    size="small"
                    onClick={handleRequestMatch}
                  >
                    Request Simulation
                  </Button>
                )}{' '}
              </Box>
            </Box>
          </Box>
          {
            <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
              <BlocklyEditor
                defaultXml={blocklyCode}
                setXmlText={setXmlText}
                workspaceDidChange={workspaceDidChange}
              />
            </Box>
          }
          {
            <Box sx={{ p: 3 }} display={tabIndex === 1 ? 'block' : 'none'}>
              <LuaEditor luaCode={luaCode} onEditorChange={onEditorChange} />
            </Box>
          }
        </Box>
      </>
    </Box>
  ) : (
    <Box display="flex" justifyContent="flex-end" pb={5}>
      {isRequestedMatch && !isSimulationStarted ? (
        <Box pr={1}>
          <Button
            variant="outlined"
            color="inherit"
            size="small"
            onClick={handleRunSimulation}
          >
            Run Simulation
          </Button>
        </Box>
      ) : (
        <></>
      )}
      {isSimulationStarted && (
        <Box>
          <Button
            variant="outlined"
            color="inherit"
            size="small"
            onClick={handleCancelSimulation}
          >
            Cancel Simulation
          </Button>
        </Box>
      )}
    </Box>
  )
}
