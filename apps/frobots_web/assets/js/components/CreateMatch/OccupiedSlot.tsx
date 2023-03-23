import React from 'react'
import { Box, Button, Typography } from '@mui/material'

type OccupiedComponentProps = {
  modifyHandler: () => any
  slotDetails: {
    avatar: string
    label: string
    bio: string
  }
}

export default ({ slotDetails, modifyHandler }: OccupiedComponentProps) => {
  return (
    <Box p={2} position={'relative'} height={'100%'}>
      <Box
        component={'img'}
        src={slotDetails?.avatar}
        width={'70%'}
        m={'auto'}
      />
      <Box mx={2} my={1}>
        <Typography variant="h6">{slotDetails?.label}</Typography>
        <Box my={1} maxHeight={60} overflow={'scroll'}>
          <Typography>{slotDetails?.bio}</Typography>
        </Box>
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
