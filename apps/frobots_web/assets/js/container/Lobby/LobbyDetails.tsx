import { Card, Typography, Box } from '@mui/material'
import React from 'react'
export default ({
  title,
  description,
  min_player_frobot,
  max_player_frobot,
  timer,
}) => {
  return (
    <Card sx={{ p: 2, px: 4, width: '100%', boxShadow: 'none' }}>
      <Box mb={4}>
        <Typography variant="h6">{title}</Typography>
      </Box>
      <Box mb={4}>
        <Typography variant="body1">About</Typography>
        <Typography variant="caption">{description || '-'}</Typography>
      </Box>
      <Box display={'flex'} gap={4} mb={2}>
        <Box display={'inline-flex'} gap={1}>
          <Typography variant="body2">Min Frobots Per Player:</Typography>
          <Typography>{min_player_frobot}</Typography>
        </Box>
        <Box display={'inline-flex'} gap={1}>
          <Typography variant="body2">Max Frobots Per Player:</Typography>
          <Typography>{max_player_frobot}</Typography>
        </Box>
      </Box>
      <Box>
        <Box display={'inline-flex'} gap={1}>
          <Typography variant="body2">Countdown Timer:</Typography>
          <Typography>{timer}</Typography>
        </Box>
      </Box>
    </Card>
  )
}
