import React from 'react'
import { Button, ButtonProps } from '@mui/material'

export default ({ sx, ...props }: ButtonProps) => {
  return (
    <Button {...props} sx={{ backgroundColor: '#00AB55', ...sx }} {...props}>
      {props.children}
    </Button>
  )
}
