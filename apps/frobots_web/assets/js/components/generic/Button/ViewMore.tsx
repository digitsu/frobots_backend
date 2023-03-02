import React from 'react'
import { ArrowForward } from '@mui/icons-material'
import { Box, Button } from '@mui/material'

export default ({ label }) => {
  return (
    <Box display={'flex'} justifyContent={'flex-end'} alignItems={'center'}>
      <Button size="small" sx={{ color: 'white' }} variant="text">
        {label}
      </Button>
      <ArrowForward sx={{ color: 'white' }} fontSize={'small'} />
    </Box>
  )
}
