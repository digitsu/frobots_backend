import React from 'react'
import { Card, SxProps } from '@mui/material'

type CardProps = {
  children: React.ReactNode
  sx?: SxProps
}

export default ({ children, sx, ...rest }: CardProps) => (
  <Card
    sx={{
      width: '100%',
      backgroundColor: '#212B36',
      color: '#fff',
      borderRadius: 4,
      ...sx,
    }}
    {...rest}
  >
    {children}
  </Card>
)
