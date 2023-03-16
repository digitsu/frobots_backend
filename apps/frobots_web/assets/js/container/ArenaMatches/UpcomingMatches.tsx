import React from 'react'
import { Box, Typography } from '@mui/material'
import { MatchContainer } from './MatchContainer'

const batteList = [
  {
    matchId: '7f54cf1e315a',
    matchName: 'Match 767',
    src: '/images/championship-mock-1.png',
    role: 'inaction',
  },
  {
    matchId: '7f54cf1e315b',
    matchName: 'Match Bingo',
    src: '/images/championship-mock-2.png',
    role: 'inaction',
  },
  {
    matchId: '7f54cf1e315c',
    matchName: 'BRAZIL 7',
    src: '/images/championship-mock-3.png',
    role: 'inaction',
  },
  {
    matchId: '7f54cf1e315d',
    matchName: 'Go to arena',
    src: '/images/championship-mock-4.png',
    role: 'inaction',
  },
  {
    matchId: '7f54cf1e315b',
    matchName: 'Galatta',
    src: '/images/championship-mock-2.png',
    role: 'spectator',
  },
  {
    matchId: '7f54cf1e315c',
    matchName: 'Royal Clash',
    src: '/images/championship-mock-3.png',
    role: 'host',
  },
]

export default () => {
  return (
    <Box>
      <Box mt={4}>
        <Typography
          fontWeight={'bold'}
          variant="subtitle1"
          sx={{ p: 2, color: '#fff' }}
        >
          In Action
        </Typography>
        <MatchContainer
          matches={batteList.filter(
            (battle: any) => battle.role === 'inaction'
          )}
        />
      </Box>

      <Box mt={4}>
        <Typography
          fontWeight={'bold'}
          variant="subtitle1"
          sx={{ p: 2, color: '#fff' }}
        >
          As Spectator
        </Typography>
        <MatchContainer
          matches={batteList.filter(
            (battle: any) => battle.role === 'spectator'
          )}
        />
      </Box>

      <Box mt={4}>
        <Typography
          fontWeight={'bold'}
          variant="subtitle1"
          sx={{ p: 2, color: '#fff' }}
        >
          As Organizer
        </Typography>
        <MatchContainer
          matches={batteList.filter((battle: any) => battle.role === 'host')}
        />
      </Box>
    </Box>
  )
}
