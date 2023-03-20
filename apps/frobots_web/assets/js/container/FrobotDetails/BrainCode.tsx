import React, { useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import { Box, Tab, Tabs, Button } from '@mui/material'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import LuaEditor from '../Garage/LuaEditor'

const brainCode = {
  avatar: "/images/frobot_bg.png",
  blockly_code: '<xml xmlns="https://developers.google.com/blockly/xml"><variables><variable id="qWi|Qnie}qC8R-C@2@^:">i</variable></variables><block type="controls_for" id="|)BG:l7`?9A|U%,}//!I" x="22" y="38"><field name="VAR" id="qWi|Qnie}qC8R-C@2@^:">i</field><value name="FROM"><shadow type="math_number" id="r1~*IbVIoH$sW$mz%@4e"><field name="NUM">1</field></shadow></value><value name="TO"><shadow type="math_number" id="D.WgL-OU6]:8pIV[D-OZ"><field name="NUM">10</field></shadow></value><value name="BY"><shadow type="math_number" id="C:i3_PH$iWWKQ/KW[FnQ"><field name="NUM">1</field></shadow></value><statement name="DO"><block type="controls_flow_statements" id="%2G981-vwQhCGyepc%rw"><field name="FLOW">BREAK</field></block></statement></block></xml>',
  brain_code:
    `--\n return function(state, ...)\n state = state or {}\n -- do nothing\n state._type = \"target\"\n return state\n end" id: 2  label  :   "Target"`,
  class: null,
  name: "New Horizon",
  xp: 1223500,
}

export default () => {
  const [luaCode, setLuaCode] = useState(brainCode.brain_code)
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(brainCode.blockly_code)

  function a11yProps(index: number) {
    return {
      id: `simple-tab-${index}`,
      'aria-controls': `simple-tabpanel-${index}`,
    }
  }

  const [tabIndex, setTabIndex] = React.useState(blocklyCode ? 0 : 1)

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setTabIndex(newValue)
  }

  useEffect(() => {
    //@ts-ignore
    window.Blockly = Blockly
    customFunctions()
  }, [])

  function onEditorChange(code) {
    try {
      console.log(code)
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

  useEffect(() => {
    setLuaCode(blocklyCode)
  }, [blocklyCode])

  // TODO : [FRO-382 brain code save logic]
  const saveConfig = () => {}

  // TODO : [FRO-383 brain code simulation logic]
  const simulateConfig = () => { }

  return (
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
              <Box>
                <Button
                  variant="outlined"
                  color="inherit"
                  size="small"
                  onClick={saveConfig}
                >
                  Save
                </Button>
                {' '}
                <Button
                  variant="outlined"
                  color="inherit"
                  size="small"
                  onClick={simulateConfig}
                >
                  Simulate
                </Button>
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
  )
}
