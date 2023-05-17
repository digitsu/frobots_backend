import React from 'react'
import { Typography, Box, Card, Grid } from '@mui/material'
import { Diversity1, Diversity2, Timeline, TaskAlt } from '@mui/icons-material'

type GlobalStats = {
  completed_matches: number
  current_matches: number
  matches_played: number
  players_online: number
  players_registered: number
  upcoming_matches: number
}

type GlobalStatsProps = {
  globalStats: GlobalStats
}

export default (props: GlobalStatsProps) => {
  const { globalStats } = props

  return (
    <Box display={'flex'} gap={2} flexDirection={'column'}>
      <Card>
        <Box px={2} py={2} height={240} width={'100%'}>
          <Typography mb={1} variant={'body2'}>
            Global Stats
          </Typography>
          <Grid container spacing={2} height={'100%'}>
            <Grid item xs={12} lg={12}>
              <Box
                display={'flex'}
                alignItems={'center'}
                justifyContent={'space-between'}
                position={'relative'}
                padding={2}
              >
                <Box display={'flex'} gap={3}>
                  <Diversity2
                    fontSize="medium"
                    sx={{
                      width: '2em',
                      height: '2em',
                      color: '#00AB55',
                    }}
                  />
                  <Box
                    display={'flex'}
                    justifyContent={'center'}
                    flexDirection={'column'}
                  >
                    <Typography variant="h6">
                      {globalStats.players_online}
                    </Typography>
                    <Typography variant="caption">Players Online</Typography>
                  </Box>
                </Box>

                <Box display={'flex'} gap={3}>
                  <Timeline
                    fontSize="medium"
                    sx={{
                      width: '2em',
                      height: '2em',
                      color: '#00AB55',
                    }}
                  />
                  <Box
                    display={'flex'}
                    justifyContent={'center'}
                    flexDirection={'column'}
                  >
                    <Typography variant="h6">
                      {globalStats.current_matches}
                    </Typography>
                    <Typography variant="caption">
                      Matches In Progress
                    </Typography>
                  </Box>
                </Box>
              </Box>
            </Grid>
            <Grid item xs={12} lg={12}>
              <Box
                display={'flex'}
                alignItems={'center'}
                justifyContent={'space-between'}
                position={'relative'}
                padding={2}
              >
                <Box display={'flex'} gap={3}>
                  <Diversity1
                    fontSize="medium"
                    sx={{
                      width: '2em',
                      height: '2em',
                      color: '#00AB55',
                    }}
                  />
                  <Box
                    display={'flex'}
                    justifyContent={'center'}
                    flexDirection={'column'}
                  >
                    <Typography variant="h6">
                      {globalStats.players_registered}
                    </Typography>
                    <Typography variant="caption">
                      Players Registered
                    </Typography>
                  </Box>
                </Box>

                <Box display={'flex'} gap={3}>
                  <TaskAlt
                    fontSize="medium"
                    sx={{
                      width: '2em',
                      height: '2em',
                      color: '#00AB55',
                    }}
                  />
                  <Box
                    display={'flex'}
                    justifyContent={'center'}
                    flexDirection={'column'}
                  >
                    <Typography variant="h6">
                      {globalStats.completed_matches}
                    </Typography>
                    <Typography variant="caption">Matches Completed</Typography>
                  </Box>
                </Box>
              </Box>
            </Grid>
          </Grid>
        </Box>
      </Card>
    </Box>
  )
}
