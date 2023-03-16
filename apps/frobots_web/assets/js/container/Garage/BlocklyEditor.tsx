import React from 'react'
import { BlocklyWorkspace } from 'react-blockly'
import { Box } from '@mui/material'
import { darkTheme } from '../../theme/blocklyTheme'
import { MY_TOOLBOX } from '../../utils/toolbarConfig'

export const BlocklyEditor: React.FC<any> = ({
  setXmlText,
  workspaceDidChange,
}) => {
  return (
    <Box display={'flex'} minHeight={'100vh'}>
      <BlocklyWorkspace
        onXmlChange={(xml) => setXmlText(xml)}
        className="blockly-editorview "
        toolboxConfiguration={MY_TOOLBOX as any}
        onWorkspaceChange={workspaceDidChange}
        workspaceConfiguration={{
          theme: darkTheme,
          grid: {
            spacing: 30,
            length: 3,
            colour: '#ccc',
          },
        }}
        initialXml={''}
      />
    </Box>
  )
}
