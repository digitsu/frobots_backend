import React, { useCallback, useEffect, useState } from 'react'
import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'
import {
  Box,
  Grid,
  Button,
  TextField,
  Tooltip,
  Typography,
  Card,
  TableBody,
  TableCell,
  TableRow,
  Table,
} from '@mui/material'
import { BlocklyEditor } from '../Garage/BlocklyEditor'
import customFunctions from '../../utils/customFunctions'
import LuaEditor from '../Garage/LuaEditor'
import Popup from '../../components/Popup'
import EditIcon from '@mui/icons-material/Edit'
import DeleteIcon from '@mui/icons-material/Delete'

const BlankBlocklyCode =
  '<xml xmlns="https://developers.google.com/blockly/xml"></xml>'

export default (props: any) => {
  const {
    currentUser,
    userSnippets,
    createUserSnippet,
    updateUserSnippet,
    deleteUserSnippet,
  } = props
  const [currentSnippet, setCurrentSnippet] = useState(null)
  const [xmlText, setXmlText] = useState(null)
  const [blocklyCode, setBlocklyCode] = useState(currentSnippet?.code)
  const [blocklyLuaCode, setBlocklyLuaCode] = useState('')
  const [showEditor, setShowEditor] = useState(false)
  const [showSaveSnippetPrompt, setShowSaveSnippetPrompt] = useState(false)
  const [showUpdateSnippetPrompt, setShowUpdateSnippetPrompt] = useState(false)
  const [showDeleteSnippetPrompt, setShowDeleteSnippetPrompt] = useState(false)
  const [isEditEnabled, setEditEnabled] = useState(false)
  const [isNewEnabled, setNewEnabled] = useState(false)
  const [newSnippetName, setNewSnippetName] = useState('')
  const workspaceElement = document.getElementById('snippet-workspace')
  const rect = workspaceElement
    ? workspaceElement.getBoundingClientRect()
    : { top: 0 }
  const distanceFromTop = rect.top + window.scrollY
  const containerMinHeight = `calc(92vh - ${distanceFromTop}px)`

  useEffect(() => {
    //@ts-ignore
    window.Blockly = Blockly
    customFunctions()
  }, [])

  useEffect(() => {
    setBlocklyLuaCode(blocklyCode)
  }, [blocklyCode])

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

  const handleSelectSnippet = (item: any) => {
    setXmlText(item.code)
    setCurrentSnippet(item)
    setBlocklyCode(item.code)
    setShowEditor(true)
    setNewEnabled(false)
    setEditEnabled(false)
    setNewSnippetName('')
  }

  const handleClickEdit = (item: any) => {
    setXmlText(item.code)
    setCurrentSnippet(item)
    setBlocklyCode(item.code)
    setNewSnippetName(item.name)
    setNewEnabled(false)
    setShowEditor(true)
    setEditEnabled(true)
  }

  const handleCreateNewSnippet = () => {
    setXmlText(null)
    setCurrentSnippet(null)
    setBlocklyCode(BlankBlocklyCode)
    setEditEnabled(false)
    setNewEnabled(true)
    setShowEditor(true)
    setNewSnippetName('')
  }

  const handleSnippetName = useCallback((event: any) => {
    setCurrentSnippet({
      id: null,
      name: event.target.value,
      code: xmlText,
      user_id: currentUser.id,
    })
  }, [])

  const handleNewSnippetName = useCallback((event: any) => {
    setNewSnippetName(event.target.value)
  }, [])

  const saveConfig = () => {
    if (!currentSnippet?.name) {
      return alert('Snippet name should not be empty.')
    }

    if (!xmlText || xmlText === BlankBlocklyCode) {
      return alert('Snippet can not be created with empty name or code')
    }

    const requestBody = {
      user_id: currentUser.id,
      code: xmlText,
      name: currentSnippet?.name,
    }

    createUserSnippet(requestBody)
    setXmlText(null)
    setCurrentSnippet(null)
    setBlocklyCode(null)
    setEditEnabled(false)
    setNewEnabled(false)
    setShowEditor(false)
    setNewSnippetName('')
    setShowSaveSnippetPrompt(false)
  }

  const updateConfig = () => {
    if (currentSnippet?.id === null) {
      return alert('Please choose a snippet to update !')
    }

    if (!newSnippetName) {
      return alert('Snippet name should not be empty.')
    }

    if (!xmlText || xmlText === BlankBlocklyCode) {
      return alert('Snippet can not be created with empty code !')
    }

    const requestBody = {
      id: currentSnippet?.id,
      code: xmlText,
      name: newSnippetName,
      user_id: currentUser.id,
    }

    updateUserSnippet(requestBody)
    setShowUpdateSnippetPrompt(false)
    setXmlText(xmlText)
    setCurrentSnippet(requestBody)
    setBlocklyCode(blocklyCode)
    setNewSnippetName('')
    setEditEnabled(false)
    setNewSnippetName('')
  }

  const handleClickDelete = (item: any) => {
    setCurrentSnippet(item)
    setXmlText(item.code)
    setBlocklyCode(item.code)
    setShowEditor(true)
    setNewEnabled(false)
    setEditEnabled(false)
    setNewSnippetName('')
    setShowDeleteSnippetPrompt(true)
  }

  const confirmDelete = useCallback(() => {
    deleteUserSnippet({ id: currentSnippet?.id })
    setXmlText(null)
    setCurrentSnippet(null)
    setBlocklyCode(BlankBlocklyCode)
    setEditEnabled(false)
    setNewSnippetName('')
    setNewEnabled(false)
    setShowEditor(false)
    setShowDeleteSnippetPrompt(false)
  }, [currentSnippet])

  return (
    <Box mt={5}>
      <>
        <Box
          sx={{
            backgroundColor: '#323332',
            m: 'auto',
            borderRadius: '10px',
            color: '#fff',
          }}
        >
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <Box
              display={'flex'}
              justifyContent={'flex-end'}
              width={'100%'}
              p={2}
            >
              <Box display={'flex'} gap={1}>
                {!isNewEnabled && !isEditEnabled && (
                  <Tooltip title={'Create new snippet'}>
                    <Button
                      onClick={handleCreateNewSnippet}
                      variant="contained"
                      color="inherit"
                      size="small"
                    >
                      {'New snippet'}
                    </Button>
                  </Tooltip>
                )}
                {isNewEnabled && (
                  <>
                    <Tooltip title={'Save your new snippet'}>
                      <Button
                        onClick={() => setShowSaveSnippetPrompt(true)}
                        variant="contained"
                        color="inherit"
                        size="small"
                      >
                        Save snippet
                      </Button>
                    </Tooltip>
                    <Popup
                      open={showSaveSnippetPrompt}
                      cancelAction={() => setShowSaveSnippetPrompt(false)}
                      successAction={saveConfig}
                      successLabel={'Confirm'}
                      cancelLabel={'Cancel'}
                      label={'Warning'}
                      description={'Do you wish to create new snippet'}
                    />
                  </>
                )}

                {isEditEnabled && (
                  <>
                    <Tooltip title={'Save your new snippet'}>
                      <Button
                        onClick={() => setShowUpdateSnippetPrompt(true)}
                        variant="contained"
                        color="inherit"
                        size="small"
                      >
                        Update snippet
                      </Button>
                    </Tooltip>

                    <Popup
                      open={showUpdateSnippetPrompt}
                      cancelAction={() => setShowUpdateSnippetPrompt(false)}
                      successAction={updateConfig}
                      successLabel={'Confirm'}
                      cancelLabel={'Cancel'}
                      label={'Warning'}
                      description={'Do you wish to update snippet'}
                    />
                  </>
                )}

                <Popup
                  open={showDeleteSnippetPrompt}
                  cancelAction={() => setShowDeleteSnippetPrompt(false)}
                  successAction={confirmDelete}
                  successLabel={'Confirm'}
                  cancelLabel={'Cancel'}
                  label={'Warning'}
                  description={'Do you wish to remove this snippet'}
                />
              </Box>
            </Box>
          </Box>
          <Box id={'snippet-workspace'}>
            <Box sx={{ p: 3 }}>
              <Grid container minHeight={containerMinHeight}>
                <Grid item xs={12} sm={12} md={2} lg={2} xl={2}>
                  <Box
                    flexDirection={'column'}
                    display={'flex'}
                    height={containerMinHeight}
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
                        <Box
                          position={'absolute'}
                          width={'100%'}
                          maxHeight={containerMinHeight}
                          sx={{
                            overflow: 'hidden',
                            overflowY: 'scroll',
                          }}
                        >
                          <Table>
                            <TableBody>
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
                                  {isNewEnabled ? (
                                    <TextField
                                      label={'Snippet name'}
                                      fullWidth
                                      value={currentSnippet?.name}
                                      onChange={handleSnippetName}
                                      size="small"
                                    />
                                  ) : (
                                    <Box>
                                      <Button
                                        color="inherit"
                                        variant="outlined"
                                        fullWidth
                                        size="small"
                                        onClick={handleCreateNewSnippet}
                                      >
                                        {'New snippet'}
                                      </Button>
                                    </Box>
                                  )}
                                </TableCell>
                              </TableRow>

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
                                    {snippet.id === currentSnippet?.id &&
                                    isEditEnabled ? (
                                      <>
                                        <TextField
                                          label={'Snippet name'}
                                          fullWidth
                                          value={newSnippetName}
                                          onChange={handleNewSnippetName}
                                          size="small"
                                        />
                                      </>
                                    ) : (
                                      <Typography
                                        variant="subtitle2"
                                        onClick={() =>
                                          handleSelectSnippet(snippet)
                                        }
                                        color={
                                          snippet.id === currentSnippet?.id
                                            ? 'primary.main'
                                            : 'inherit'
                                        }
                                      >
                                        {snippet.name}
                                      </Typography>
                                    )}
                                  </TableCell>

                                  <TableCell
                                    sx={{
                                      color: '#fff',
                                      borderColor: '#333D49',
                                      display: 'flex',
                                      p: 2,
                                      px: '0px !important',
                                      justifyContent: 'end',
                                    }}
                                    align="left"
                                  >
                                    <Tooltip title="Edit">
                                      <Button
                                        variant="text"
                                        color="inherit"
                                        size="small"
                                        onClick={() => handleClickEdit(snippet)}
                                        sx={{
                                          minWidth: '30px !important',
                                        }}
                                      >
                                        <EditIcon fontSize="small" />
                                      </Button>
                                    </Tooltip>
                                    <Tooltip title="Remove">
                                      <Button
                                        variant="text"
                                        color="inherit"
                                        size="small"
                                        onClick={() =>
                                          handleClickDelete(snippet)
                                        }
                                        sx={{
                                          minWidth: '30px !important',
                                        }}
                                      >
                                        <DeleteIcon fontSize="small" />
                                      </Button>
                                    </Tooltip>
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
                <Grid item xs={12} sm={12} md={10} lg={10} xl={10}>
                  <Box display={showEditor ? 'flex' : 'none'} height={'100%'}>
                    <Grid container height={containerMinHeight}>
                      <Grid
                        item
                        xs={12}
                        sm={12}
                        md={8}
                        lg={8}
                        xl={8}
                        height={'100%'}
                      >
                        <BlocklyEditor
                          key={blocklyCode}
                          defaultXml={blocklyCode}
                          setXmlText={setXmlText}
                          workspaceDidChange={workspaceDidChange}
                        />
                      </Grid>
                      <Grid
                        item
                        xs={12}
                        sm={12}
                        md={4}
                        lg={4}
                        xl={4}
                        height={'100%'}
                      >
                        <LuaEditor
                          luaCode={blocklyLuaCode}
                          onEditorChange={() => {}}
                        />
                      </Grid>
                    </Grid>
                  </Box>
                  <Box display={showEditor ? 'none' : 'block'} height={'100%'}>
                    <Card
                      sx={{
                        height: containerMinHeight,
                        borderRadius: '0 !important',
                      }}
                    >
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
                            {'Snippets'}
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
                              {
                                'You can view the details for a snippet by clicking it'
                              }
                            </Typography>
                          )}
                        </Box>
                      </Box>
                    </Card>
                  </Box>
                </Grid>
              </Grid>
            </Box>
          </Box>
        </Box>
      </>
    </Box>
  )
}
