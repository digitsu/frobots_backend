import React from 'react'
import { Typography, Box, Card } from '@mui/material'

const topPlayers = [
  {
    name: '2920',
    color: '#00AB55',
    details: 'Players Online',
  },
  {
    name: '72',
    color: '#FFAB00',
    details: 'Matches In Progress',
  },
  {
    name: '4729',
    color: '#00B8D9',
    details: 'Players Registered',
  },
  {
    name: '12412312',
    color: '#FFAB00',
    details: 'Matches Completed',
  },
]
export default () => {
  return (
    <Card>
      <Box px={2} py={2} maxHeight={240}>
        <Typography mb={1} variant={'body2'}>
          Global Stats
        </Typography>
        <Box flexDirection={'column'} display={'flex'} gap={1}>
          {topPlayers.map((playerDetails, index) => (
            <Box
              display={'flex'}
              gap={1}
              alignItems={'flex-start'}
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
                  bgcolor={playerDetails.color}
                ></Box>
                {index !== topPlayers.length - 1 && (
                  <Box
                    component={'div'}
                    width={'1px'}
                    bgcolor={'gray'}
                    height={'20px'}
                  />
                )}
              </Box>
              <Box>
                <Typography variant="body2">{playerDetails.name}</Typography>
                <Typography fontSize={11} color={'lightslategray'}>
                  {playerDetails.details}
                </Typography>
              </Box>
            </Box>
          ))}
        </Box>
      </Box>
    </Card>
  )
}
