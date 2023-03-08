import { Box, Button } from '@mui/material'
import React from 'react'
import FrobotListContainer from './FrobotListContainer'
export default () => (
  <Box>
    <Box
      display={'flex'}
      alignItems={'center'}
      justifyContent={'flex-end'}
      mt={4}
    >
      <Button sx={{ textTransform: 'capitalize' }} variant="outlined">
        Buy Sparks
      </Button>
    </Box>
    <Box mt={4}>
      {' '}
      <FrobotListContainer />
    </Box>
  </Box>
)
