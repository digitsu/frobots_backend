import React from 'react'
import { Box, Card, Typography } from '@mui/material'
export default ({
  s3_base_Url,
  frobot,
  user_name,
  health,
  xp_earned,
  kills,
  winner,
}) => {
  return (
    <Card sx={{ py: 2, px: 4 }}>
      <Box
        display={'flex'}
        alignItems={'center'}
        justifyContent={'space-between'}
        gap={2}
      >
        <Box flex={1}>
          <Box
            component={'img'}
            src={`${s3_base_Url}${frobot.avatar}`}
            width={80}
          />
        </Box>
        <Box flex={2}>
          <Typography variant="subtitle1">{frobot.name}</Typography>
          <Typography>{user_name}</Typography>
          <Typography>XP: {frobot.xp}</Typography>
        </Box>
        <Box flex={2}>
          <Typography variant="body2">Health: {health}%</Typography>
          <Typography variant="body2">XP Earned: +{xp_earned}</Typography>
          <Typography variant="body2">Kills: {kills}</Typography>
        </Box>
        <Box flex={1}>
          <Typography
            variant="caption"
            color={winner.includes(frobot.id) ? '#00AB55' : '#FF0000'}
          >
            {winner.includes(frobot.id) ? 'Winner' : 'Lost'}
          </Typography>
        </Box>
      </Box>
    </Card>
  )
}
