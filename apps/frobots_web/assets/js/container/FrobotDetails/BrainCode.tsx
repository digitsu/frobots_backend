import React, { useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import {
  Box,
  Grid,
  Tab,
  Tabs,
  Button,
  Autocomplete,
  TextField,
  Chip,
} from '@mui/material'
import LuaEditor from '../Garage/LuaEditor'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import { Game } from '../../game'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const {
    frobot,
    currentUser,
    updateFrobotCode,
    requestMatch,
    runSimulation,
    cancelSimulation,
    changeProtobot,
    templates,
  } = props
  const isOwnFrobot = frobot.user_id === currentUser.id
  const [luaCode, setLuaCode] = useState(frobot.brain_code || '')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(
    frobot.blockly_code || BlankBlocklyCode
  )
  const [gameState, setGameState] = useState({ event: () => {} })
  const [blocklyLuaCode, setBlocklyLuaCode] = useState('')
  const [isSelectedProtobot, setIsSelectedProtobot] = useState(false)
  const [isRequestedMatch, setIsRequestedMatch] = useState(false)
  const [isSimulationStarted, setIsSimulationStarted] = useState(false)
  const [opponents, setOpponents] = useState([])
  const templateFrobots =
    templates?.map(({ name, id }, index) => ({
      label: name,
      id: id,
    })) || []

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

  useEffect(() => {
    setBlocklyLuaCode(blocklyCode)
  }, [blocklyCode])

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
      frobot_id: frobot.id,
      blockly_code: xmlText,
      brain_code: luaCode,
    }

    updateFrobotCode(requestBody)
  }

  const handleRunSimulation = () => {
    if (!luaCode || luaCode.trim() === '') {
      return alert("Simulation can't be started with empty lua code")
    } else {
      runSimulation({ frobot_id: frobot.id })
      setIsSimulationStarted(true)
      setIsRequestedMatch(true)
    }
  }

  const handleCancelSimulation = () => {
    cancelSimulation()
    setIsRequestedMatch(false)
    setIsSimulationStarted(false)
    setIsSelectedProtobot(false)
    gameState.destroy()
  }

  const handleChangeOpponent = (_event, option) => {
    if (option?.length >= 1) {
      const ids = option.map(({ id }) => id)
      changeProtobot({ protobot_ids: ids })
      setIsSelectedProtobot(true)
      setOpponents(option)
    } else {
      setOpponents([])
      setIsSelectedProtobot(false)
    }
  }
  const filteredOptions = templateFrobots.filter(
    (option) => !opponents.map(({ id }) => id).includes(option.id)
  )

  useEffect(() => {
    if (isSimulationStarted) {
      const game = new Game([], [], {
        match_id: null,
        match_details: { type: 'simulation', id: frobot?.id },
        arena: null,
        s3_base_url: '',
      })
      game.header()
      if (game !== null) {
        //  const frobots = slots.filter((slot) => slot.frobot !== null)
        // for(let i=0;i<frobots.length ; i++){
        //     game.event({args : [frobots[i].frobot.name,[200,300]], event : 'create_tank'})
        // }
        setGameState(game)
      }
    }
  }, [isSimulationStarted])

  window.addEventListener(`phx:simulator_event`, (e) => {
    gameState.event(e.detail)
  })
  return !isRequestedMatch ? (
    <Box mt={5}>
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
              <Box flex={5}>
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
              <Box display={'flex'} flex={6} mb={1} alignItems={'center'}>
                {isOwnFrobot && (
                  <Button
                    variant="outlined"
                    color="inherit"
                    size="small"
                    onClick={saveConfig}
                    sx={{ flex: 1 }}
                  >
                    Save
                  </Button>
                )}{' '}
                <Autocomplete
                  sx={{
                    pl: 1,
                    pr: 1,
                    width: 200,
                    flex: isSelectedProtobot ? 3 : 5,
                  }}
                  multiple
                  key={'opponents'}
                  onChange={handleChangeOpponent}
                  options={filteredOptions}
                  renderTags={(value, getTagProps) =>
                    value.map((option, index) => (
                      <div key={index} style={{ display: 'inline-block' }}>
                        <Chip
                          label={option.label}
                          {...getTagProps({ index })}
                        />
                      </div>
                    ))
                  }
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
                    onClick={handleRunSimulation}
                    sx={{ flex: 1 }}
                  >
                    Simulate
                  </Button>
                )}{' '}
              </Box>
            </Box>
          </Box>
          {
            <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
              <Grid container>
                <Grid item xs={12} sm={12} md={6} lg={6} xl={6}>
                  <BlocklyEditor
                    defaultXml={blocklyCode}
                    setXmlText={setXmlText}
                    workspaceDidChange={workspaceDidChange}
                  />
                </Grid>
                <Grid item xs={12} sm={12} md={6} lg={6} xl={6}>
                  <LuaEditor
                    luaCode={blocklyLuaCode}
                    onEditorChange={() => {}}
                  />
                </Grid>
              </Grid>
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
      {isSimulationStarted && (
        <>
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
        </>
      )}
    </Box>
  )
}
