import React, { useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import { Box, Tab, Tabs, Button } from '@mui/material'
import LuaEditor from '../Garage/LuaEditor'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const { frobot, updateFrobotCode } = props
  const [isEditable, enableEdit] = useState(false)
  const [luaCode, setLuaCode] = useState(frobot.brain_code || '')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(
    frobot.blockly_code || BlankBlocklyCode
  )

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
