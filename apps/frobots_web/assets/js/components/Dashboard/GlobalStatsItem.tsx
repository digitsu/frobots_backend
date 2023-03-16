import React from 'react'
import { Box, Typography } from '@mui/material'

export default ({ color, index, label, subtitle }) => {
  return (
    <Box
      display={'flex'}
      gap={1}
      alignItems={'baseline'}
      justifyContent={'flex-start'}
    >
      <Box
        gap={1}
        display={'flex'}
        flexDirection={'column'}
        alignItems={'center'}
      >
        <Box
          component={'div'}
          width={12}
          minHeight={12}
          borderRadius={'50%'}
          bgcolor={color}
        ></Box>
        {index !== 3 && (
          <Box
            component={'div'}
            width={'1px'}
            bgcolor={'gray'}
            height={'16px'}
          />
        )}
      </Box>
      <Box>
        <Typography variant="body2">{label}</Typography>
        <Typography fontSize={11} color={'lightslategray'}>
          {subtitle}
        </Typography>
      </Box>
    </Box>
  )
}
