import React, { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import { Box, Tab, Tabs, Button } from '@mui/material'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import customFunctions from '../../utils/customFunctions'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import LuaEditor from '../Garage/LuaEditor'

export default () => {
  const { brainCode } = useSelector((store: any) => store.createFrobot)
  const [luaCode, setLuaCode] = useState('')
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState('')

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

  useEffect(() => {
    if (brainCode !== null) {
      const { brain_code } = brainCode || {}
      setLuaCode(brain_code)
    }
  }, [brainCode])

  function onEditorChange(code) {
    try {
      console.log(code)
    } catch (err) {
      console.log(err)
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
                    label="Lua Code"
                    {...a11yProps(1)}
                  />
                </Tabs>
              </Box>
              <Box>
                <Button variant="outlined" onClick={downloadConfig}>
                  Download
                </Button>
              </Box>
            </Box>
          </Box>
          {
            <Box sx={{ p: 3 }} display={tabIndex === 0 ? 'block' : 'none'}>
              <BlocklyEditor
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
