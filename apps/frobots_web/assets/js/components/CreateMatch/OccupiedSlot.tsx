import React from 'react'
import { Box, Button, Typography } from '@mui/material'

type OccupiedComponentProps = {
  modifyHandler: () => any
  slotDetails: {
    avatar: string
    name: string
    bio: string
  }
  imageBaseUrl: string
}

export default ({
  slotDetails,
  modifyHandler,
  imageBaseUrl,
}: OccupiedComponentProps) => {
  return (
    <Box p={2} position={'relative'} height={'100%'}>
      <Box
        component={'img'}
        src={`${imageBaseUrl}${slotDetails?.avatar}`}
        width={'60%'}
        m={'auto'}
      />
      <Box mx={2} my={1}>
        <Typography variant="h6">{slotDetails?.name}</Typography>
        <Box
          my={1}
          sx={{
            maxHeight: '45px',
            overflowY: 'scroll',
            '&::-webkit-scrollbar': { display: 'none' },
          }}
        >
          <Typography variant="caption">{slotDetails?.bio || ''}</Typography>
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
