import { Box, Button, Typography } from '@mui/material'
import React from 'react'

type UnoccupiedComponentProps = {
  modifyHandler: () => any
  type: string
}
export default ({ modifyHandler, type }: UnoccupiedComponentProps) => {
  const label = type.toLocaleLowerCase() === 'open' ? 'Open' : 'Closed'
  return (
    <Box position={'relative'} height={'100%'}>
      <Box position={'relative'} height={'100%'}>
        <Box
          sx={{ filter: 'grayscale(1)' }}
          component={'img'}
          src={'/images/creatematch_bg.png'}
          width={'100%'}
          height={'100%'}
        ></Box>
        <Typography
          variant="h6"
          display={'flex'}
          justifyContent={'center'}
          width={'100%'}
          position={'absolute'}
          top={'50%'}
        >
          {label}
        </Typography>
      </Box>
      <Box
        sx={{
          position: 'absolute',
          left: '50%',
          px: 4,
          transform: 'translate(-50%, -50%)',
          width: '100%',
          bottom: 0,
        }}
      >
        <Button fullWidth variant="contained" onClick={modifyHandler}>
          Modify
        </Button>
      </Box>
    </Box>
  )
}
