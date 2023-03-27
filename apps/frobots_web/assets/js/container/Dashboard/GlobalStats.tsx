import React from 'react'
import { Typography, Box, Card } from '@mui/material'
import GlobalStatsItem from '../../components/Dashboard/GlobalStatsItem'

type GlobalStats = {
  matches_completed: number
  matches_in_progress: number
  players_online: number
  players_registered: number
}

type GlobalStatsProps = {
  globalStats: GlobalStats
}

export default (props: GlobalStatsProps) => {
  const { globalStats } = props

  return (
    <Card>
      <Box px={2} py={2} maxHeight={240}>
        <Typography mb={1} variant={'body2'}>
          Global Stats
        </Typography>
        <Box flexDirection={'column'} display={'flex'} gap={1}>
          <GlobalStatsItem
            color={'#00AB55'}
            subtitle={'Players Online'}
            label={globalStats?.players_online}
            index={0}
          />
          <GlobalStatsItem
            color={'#FFAB00'}
            subtitle={'Matches In Progress'}
            label={globalStats?.matches_in_progress}
            index={1}
          />
          <GlobalStatsItem
            color={'#00B8D9'}
            subtitle={'Players Registered'}
            label={globalStats?.players_registered}
            index={2}
          />
          <GlobalStatsItem
            color={'#FFAB00'}
            subtitle={'Matches Completed'}
            label={globalStats?.matches_completed}
            index={3}
          />
        </Box>
      </Box>
    </Card>
  )
}
