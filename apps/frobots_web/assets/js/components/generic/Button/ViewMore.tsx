import React from 'react'
import { ArrowForward } from '@mui/icons-material'
import { Box, Button } from '@mui/material'

export default ({ label, link = '' }) => {
  return (
    <Box display={'flex'} justifyContent={'flex-end'} alignItems={'center'}>
      <Button
        size="small"
        sx={{ color: 'white', textTransform: 'uppercase' }}
        variant="text"
        href={link}
      >
        {label}
      </Button>
      <ArrowForward sx={{ color: 'white' }} fontSize={'small'} />
    </Box>
  )
}
