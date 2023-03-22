import React, { useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import { Box, Tab, Tabs, Button } from '@mui/material'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import LuaEditor from '../Garage/LuaEditor'

export default (props: any) => {
  const { frobot, ...others } = props
  const [luaCode, setLuaCode] = useState(frobot.brain_code || '')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(frobot.blockly_code || '')

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
  const simulateConfig = () => {}

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
                </Button>{' '}
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
                defaultXml={blocklyCode || ''}
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
