import React from 'react'
import { Box, Button, Typography } from '@mui/material'

type OccupiedComponentProps = {
  modifyHandler: () => any
  slotDetails: {
    avatar: string
    name: string
    bio: string
  }
  imageBaseUrl?: string
  showModifyButton?: boolean
  s3_base_url?: string
  showRemoveButton?: boolean
  clearFrobotHandler?: () => any
}

export default ({
  slotDetails,
  modifyHandler,
  showModifyButton = true,
  s3_base_url,
  showRemoveButton = false,
  clearFrobotHandler,
}: OccupiedComponentProps) => {
  return (
    <Box
      p={2}
      position={'relative'}
      height={'100%'}
      display={'flex'}
      flexDirection={'column'}
      justifyContent={'space-between'}
    >
      <Box>
        <Box
          component={'img'}
          src={`${s3_base_url}${slotDetails?.avatar}`}
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
      </Box>
      <Box>
        {showRemoveButton && (
          <Box mb={1}>
            <Button fullWidth variant="outlined" onClick={clearFrobotHandler}>
              Remove
            </Button>
          </Box>
        )}
        {showModifyButton && (
          <Button fullWidth variant="contained" onClick={modifyHandler}>
            Modify
          </Button>
        )}
      </Box>
    </Box>
  )
}
