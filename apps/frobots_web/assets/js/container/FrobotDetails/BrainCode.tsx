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
  Tooltip,
} from '@mui/material'
import LuaEditor from '../Garage/LuaEditor'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import { Game, rigHead } from '../../game_updated'
import { Rig } from '../../rig'
import * as PIXI from 'pixi.js'
import Popup from '../../components/Popup'
import {
  BrainCodeCopyPromptDescription,
  SaveBlockCodePromptDescription,
  SaveBrainCodePromptDescription,
} from '../../mock/texts'
import SaveIcon from '@mui/icons-material/Save'
import PlayArrowIcon from '@mui/icons-material/PlayArrow'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const {
    frobot,
    currentUser,
    updateFrobotCode,
    runSimulation,
    cancelSimulation,
    changeProtobot,
    templates,
  } = props
  const isOwnFrobot = frobot.user_id === currentUser.id
  const [luaCode, setLuaCode] = useState(frobot.brain_code || '')
  const [showCopyPrompt, setShowCopyPrompt] = useState(false)
  const [showSaveCodePrompt, setShowSaveCodePrompt] = useState(false)
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(
    frobot.blockly_code || BlankBlocklyCode
  )
  const [gameState, setGameState] = useState(null)
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
      if (!code) {
        setBlocklyLuaCode('')
      } else if (code != blocklyCode) {
        setBlocklyLuaCode(code)
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
    setShowSaveCodePrompt(false)
  }
  const handleCopyConfirm = () => {
    setLuaCode(blocklyLuaCode)
    setShowCopyPrompt(false)
  }

  const handleSaveCode = () => {
    if (blocklyLuaCode === luaCode) {
      saveConfig()
    } else {
      setShowSaveCodePrompt(true)
    }
  }

  const downloadConfig = () => {
    const isBlockly = tabIndex === 0
    const fileType = isBlockly ? 'text/xml' : 'text/lua'
    const fileContent = isBlockly ? xmlText : luaCode
    const xmlBlob = new Blob([fileContent], { type: fileType })
    const xmlUrl = URL.createObjectURL(xmlBlob)
    const a = document.createElement('a')
    a.href = xmlUrl
    a.download = isBlockly ? 'blockly-config.xml' : 'lua-code.lua'
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
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
    setOpponents([])
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

  const handleGameEvent = (e) => {
    if (e.detail.id && gameState === null) {
      const players = e.detail.slots.map((slot) => ({
        name: `${slot.frobot.name}#${slot.id}`,
        displayName: slot.frobot.name,
      }))
      const rigs = players.map(({ name, displayName }) => {
        var asset = rigHead(name)
        var rig_sprite = new PIXI.Sprite(
          PIXI.Texture.from('/images/' + asset + '.png')
        )
        rig_sprite.x = 0
        rig_sprite.y = 0
        rig_sprite.width = 15
        rig_sprite.height = 15
        return {
          Rig: new Rig(
            `${name}`,
            748,
            610,
            219,
            100,
            rig_sprite,
            0,
            displayName
          ),
          asset: { [`${name}`]: asset },
        }
      })

      if (isSimulationStarted) {
        const game = new Game(
          rigs.map(({ Rig }) => Rig),
          [],
          {
            match_id: null,
            match_details: { type: 'simulation', id: frobot?.id },
            arena: null,
            s3_base_url: '',
            rigIcons: rigs.map(({ asset }) => asset),
          }
        )
        game.header()
        if (game !== null) {
          setGameState(game)
        }
      }
    } else {
      if (gameState) {
        gameState.event(e.detail)
      }
    }
  }
  window.addEventListener(`phx:simulator_event`, handleGameEvent)

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
                    label="Block Editor"
                    {...a11yProps(0)}
                  />
                  <Tab
                    sx={{ color: '#fff' }}
                    label="Brain Code"
                    {...a11yProps(1)}
                  />
                </Tabs>
              </Box>
              <Box
                display={'flex'}
                flex={6}
                mb={1}
                gap={1}
                alignItems={'center'}
              >
                {currentUser.admin && (
                  <Tooltip title={'Download Brain Code'}>
                    <Button
                      color="inherit"
                      variant="outlined"
                      size="small"
                      sx={{ p: 1 }}
                      onClick={downloadConfig}
                    >
                      Download
                    </Button>
                  </Tooltip>
                )}
                {isOwnFrobot && (
                  <>
                    <Tooltip title={'Save Brain Code'}>
                      <Button
                        variant="outlined"
                        color="inherit"
                        size="small"
                        onClick={handleSaveCode}
                        sx={{ p: 1 }}
                      >
                        <SaveIcon />
                      </Button>
                    </Tooltip>
                    <Popup
                      open={showSaveCodePrompt}
                      cancelAction={() => setShowSaveCodePrompt(false)}
                      successAction={saveConfig}
                      successLabel={'Confirm'}
                      cancelLabel={'Cancel'}
                      label={'Warning'}
                      description={
                        tabIndex === 0
                          ? SaveBlockCodePromptDescription
                          : SaveBrainCodePromptDescription
                      }
                    />
                  </>
                )}
                <Autocomplete
                  sx={{
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
                <Box display={'flex'} gap={1}>
                  {isSelectedProtobot && (
                    <Tooltip title={'Run Simulation'}>
                      <Button
                        variant="outlined"
                        color="inherit"
                        size="small"
                        onClick={handleRunSimulation}
                        sx={{ flex: 1 }}
                      >
                        <PlayArrowIcon />
                      </Button>
                    </Tooltip>
                  )}
                  {tabIndex === 0 && (
                    <Tooltip title={'Sync Brain Code'}>
                      <Button
                        onClick={() => setShowCopyPrompt(true)}
                        variant="contained"
                        color="inherit"
                      >
                        Sync
                      </Button>
                    </Tooltip>
                  )}
                </Box>
                <Popup
                  open={showCopyPrompt}
                  cancelAction={() => setShowCopyPrompt(false)}
                  successAction={handleCopyConfirm}
                  successLabel={'Confirm'}
                  cancelLabel={'Cancel'}
                  label={'Warning'}
                  description={BrainCodeCopyPromptDescription}
                />
              </Box>
            </Box>
          </Box>
          {
            <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
              <Grid container>
                <Grid item xs={12} sm={12} md={8} lg={8} xl={8}>
                  <BlocklyEditor
                    defaultXml={blocklyCode}
                    setXmlText={setXmlText}
                    workspaceDidChange={workspaceDidChange}
                  />
                </Grid>
                <Grid item xs={12} sm={12} md={4} lg={4} xl={4}>
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
          <Grid container spacing={1}>
            <Grid item md={12}>
              <Box my={2} display={'flex'} justifyContent={'flex-end'}>
                <Button
                  variant="outlined"
                  color="inherit"
                  size="small"
                  onClick={handleCancelSimulation}
                >
                  Cancel Simulation
                </Button>
              </Box>
            </Grid>
            <Grid item sm={12} md={9} lg={9} xl={9}>
              {' '}
              <Box id="garage-simulation" />
            </Grid>
            <Grid item sm={12} md={3} lg={3} xl={3}>
              <Box id="game-stats" />
            </Grid>
          </Grid>
        </>
      )}
    </Box>
  )
}
