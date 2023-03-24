import React from 'react'
import { Paper, Box } from '@mui/material'
import Table from '../../components/generic/Table'
import ViewMore from '../../components/generic/Button/ViewMore'

function createData(
  id: number,
  name: string,
  player: string,
  xp: string,
  wins: number,
  rank: number,
  avatar: string
) {
  return { id, name, player, xp, wins, rank, avatar }
}

const rows = [
  createData(
    1,
    'XTron',
    'DJC',
    '297600 XP',
    12121212,
    1,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    2,
    'Davincy Resolve',
    'Excel7',
    '297600 XP',
    3123123,
    2,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    3,
    'Biohazard',
    'Excel7',
    '297600 XP',
    45123123,
    3,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    3,
    'Biohazard',
    'Excel7',
    '297600 XP',
    1231231234,
    4,
    '/images/leaderboard-mock-avatar.png'
  ),
  createData(
    3,
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
