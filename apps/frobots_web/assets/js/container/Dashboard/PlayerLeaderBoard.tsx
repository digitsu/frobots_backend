import React from 'react'
import { Paper, Box } from '@mui/material'
import { ArrowForward } from '@mui/icons-material'
import Table from '../../components/generic/Table'
import ViewMore from '../../components/generic/Button/ViewMore'

function createData(
  name: string,
  player: string,
  xp: string,
  wins: number,
  rank: number,
  avatar: string
) {
  return { name, player, xp, wins, rank, avatar }
}

const rows = [
  createData(
    'XTron',
    'DJC',
    '297600 XP',
    12121212,
    1,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    'Davincy Resolve',
    'Excel7',
    '297600 XP',
    3123123,
    2,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    'Biohazard',
    'Excel7',
    '297600 XP',
    45123123,
    3,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    'Biohazard',
    'Excel7',
    '297600 XP',
    1231231234,
    4,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    'Biohazard',
    'Excel7',
    '297600 XP',
    4412333,
    5,
    '/images/leaderboard-mock-avatar.png'
  ),
]

const tableHeads = ['Frobot', 'Player', 'XP', 'Wins', 'Rank']

export default () => {
  return (
    <Paper sx={{ backgroundColor: '#212B36', borderRadius: 4 }}>
      <Table
        tableData={rows}
        tableTitle={'Player Leaderboard'}
        tableHeads={tableHeads}
      />
      <Box px={2} py={1}>
        <ViewMore label={'View More'} />
      </Box>
    </Paper>
  )
}
