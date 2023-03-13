import React from 'react'
import Editor from '@monaco-editor/react'
export default ({ luaCode, onEditorChange }) => {
  return (
    <Editor
      height={'100vh'}
      value={luaCode}
      language="lua"
      theme="vs-dark"
      onChange={onEditorChange}
    />
  )
}
