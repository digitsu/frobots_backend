import React from 'react'
import { BlocklyWorkspace } from 'react-blockly'
import { Box } from '@mui/material'
import { darkTheme } from '../../theme/blocklyTheme'
import { MY_TOOLBOX } from '../../utils/toolbarConfig'
import { CrossTabCopyPaste } from '@blockly/plugin-cross-tab-copy-paste'

// Initiate cross tab copy paste feature
const plugin = new CrossTabCopyPaste()
plugin.init({ contextMenu: true, shortcut: true })

export const BlocklyEditor: React.FC<any> = ({
  defaultXml = '',
  setXmlText,
  workspaceDidChange,
  key = '',
}) => {
  return (
    <Box display={'flex'} minHeight={'100%'}>
      <BlocklyWorkspace
        onXmlChange={(xml) => setXmlText(xml)}
        className="blockly-editorview"
        toolboxConfiguration={MY_TOOLBOX as any}
        onWorkspaceChange={workspaceDidChange}
        workspaceConfiguration={{
          theme: darkTheme,
          grid: {
            spacing: 30,
            length: 3,
            colour: '#ccc',
          },
          move: {
            drag: true,
            wheel: true,
          },
          scrollbars: true,
          zoom: {
            controls: true,
            wheel: true,
            startScale: 0.9,
            maxScale: 3,
            minScale: 0.3,
            scaleSpeed: 1.2,
          },
        }}
        initialXml={defaultXml}
      />
    </Box>
  )
}
