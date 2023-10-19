import React, { useEffect, useState } from 'react'
import {
  Box,
  Grid,
  Typography,
  Card,
  Link,
  TableRow,
  Table,
  TableBody,
  TableCell,
  Button,
} from '@mui/material'
import { luaGenerator } from 'blockly/lua'
import LuaEditor from '../Garage/LuaEditor'
import { BlocklyEditor } from '../Garage/BlocklyEditor'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const { userSnippets, heightValue } = props
  const [currentSnippet, setCurrentSnippet] = useState(null)
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(
    currentSnippet?.code || BlankBlocklyCode
  )
  const [blocklyLuaCode, setBlocklyLuaCode] = useState('')
  const [showEditor, setShowEditor] = useState(false)

  useEffect(() => {
    setBlocklyLuaCode(blocklyCode)
  }, [blocklyCode])

  const workspaceDidChange = (workspace: any) => {
    setBlocklyCode(currentSnippet?.code)
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

  const handleSelectSnippet = (item: any) => {
    setXmlText(null)

    setCurrentSnippet(item)
    setBlocklyCode(item.code)
    setShowEditor(true)
  }

  const handleGoToSnippet = () => {
    window.location.href = '/snippets'
  }

  return (
    <Grid container height={heightValue}>
      <Grid item xs={12} sm={12} md={2} lg={2} xl={2} height={'100%'}>
        <Box
          flexDirection={'column'}
          display={'flex'}
          height={heightValue}
          sx={{
            borderRight: 1,
            borderColor: 'divider',
          }}
        >
          <Card sx={{ height: '100%', borderRadius: 0 }}>
            <Box position={'relative'} height={'100%'}>
              <Box
                sx={{ filter: 'grayscale(1)' }}
                component={'img'}
                src={'/images/creatematch_bg.png'}
                width={'100%'}
                height={'100%'}
                display={'none'}
              />
              {userSnippets.length === 0 && (
                <Box
                  position={'absolute'}
                  top={'40%'}
                  width={'100%'}
                  height={'100%'}
                  textAlign={'center'}
                >
                  <Typography
                    variant="h6"
                    display={'flex'}
                    justifyContent={'center'}
                    mb={2}
                  >
                    {"You haven't created any snippets"}
                  </Typography>
                  <Link href="/snippets" underline="none" variant="body2">
                    {'Create New Snippet'}
                  </Link>
                </Box>
              )}

              <Box
                position={'absolute'}
                width={'100%'}
                maxHeight={'100%'}
                sx={{
                  overflow: 'hidden',
                  overflowY: 'scroll',
                }}
              >
                <Table>
                  <TableBody>
                    {userSnippets.length !== 0 && (
                      <TableRow
                        sx={{
                          cursor: 'pointer',
                          '&:hover': {
                            backgroundColor: 'action.hover',
                          },
                          borderBottom: '1px solid #555454',
                        }}
                      >
                        <TableCell
                          colSpan={2}
                          sx={{
                            color: '#fff',
                            borderColor: '#333D49',
                            p: 2,
                            pl: '8px !important',
                            pr: '8px !important',
                          }}
                          align="left"
                        >
                          <Box>
                            <Button
                              color="inherit"
                              variant="outlined"
                              fullWidth
                              size="small"
                              onClick={handleGoToSnippet}
                            >
                              {'Go to snippets manager'}
                            </Button>
                          </Box>
                        </TableCell>
                      </TableRow>
                    )}

                    {userSnippets.map((snippet: any) => (
                      <TableRow
                        key={snippet.id}
                        sx={{
                          cursor: 'pointer',
                          '&:hover': {
                            backgroundColor: 'action.hover',
                          },
                          borderBottom: '1px solid #555454',
                        }}
                        onClick={() => handleSelectSnippet(snippet)}
                      >
                        <TableCell
                          sx={{
                            color: '#fff',
                            borderColor: '#333D49',
                            p: 2,
                            pl: '8px !important',
                            pr: '0px !important',
                          }}
                          align="left"
                        >
                          <Typography
                            variant="subtitle2"
                            color={
                              snippet.id === currentSnippet?.id
                                ? 'primary.main'
                                : 'inherit'
                            }
                          >
                            {snippet.name}
                          </Typography>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </Box>
            </Box>
          </Card>
        </Box>
      </Grid>
      <Grid item xs={12} sm={12} md={10} lg={10} xl={10} height={'100%'}>
        <Grid container display={showEditor ? 'flex' : 'none'} height={'100%'}>
          <Grid item xs={12} sm={12} md={8} lg={8} xl={8}>
            <BlocklyEditor
              key={currentSnippet?.id}
              defaultXml={blocklyCode}
              setXmlText={setXmlText}
              workspaceDidChange={workspaceDidChange}
            />
          </Grid>
          <Grid item xs={12} sm={12} md={4} lg={4} xl={4}>
            <LuaEditor luaCode={blocklyLuaCode} onEditorChange={() => {}} />
          </Grid>
        </Grid>
        <Box display={showEditor ? 'none' : 'block'} height={'100%'}>
          <Card sx={{ height: '100%', borderRadius: '0 !important' }}>
            <Box position={'relative'} height={'100%'}>
              <Box
                sx={{ filter: 'grayscale(1)' }}
                component={'img'}
                src={'/images/creatematch_bg.png'}
                width={'100%'}
                height={'100%'}
              ></Box>
              <Box position={'absolute'} top={'40%'} width={'100%'}>
                <Typography
                  variant="h3"
                  display={'flex'}
                  justifyContent={'center'}
                >
                  Snippets
                </Typography>
                <Typography
                  variant="h6"
                  display={'flex'}
                  justifyContent={'center'}
                >
                  {
                    'Create your own blockly function snippet that can be copied and pasted into any frobot braincode.'
                  }
                </Typography>
                {userSnippets.length !== 0 && (
                  <Typography
                    variant="body1"
                    display={'flex'}
                    justifyContent={'center'}
                  >
                    {'You can view the details for a snippet by clicking it'}
                  </Typography>
                )}
              </Box>
            </Box>
          </Card>
        </Box>
      </Grid>
    </Grid>
  )
}
