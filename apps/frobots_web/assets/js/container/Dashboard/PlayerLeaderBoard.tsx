import React from 'react'
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Typography,
  Box,
} from '@mui/material'
import EmptyTableData from '../../components/generic/EmptyTableData'

const tableHeads = ['Player', 'Frobots', 'XP', 'Wins', 'Rank']

interface PlayerLeaderBoard {
  id: number
  attempts: string
  avatar: string
  frobot_count: number
  matches_participated: number
  matches_won: string
  points: number
  rank: number
  username: string
  useremail: string
  xp: number
}

interface LeaderBoardProps {
  leaderBoardData: PlayerLeaderBoard[]
  imageBaseUrl: string
}

export default (props: LeaderBoardProps) => {
  const { leaderBoardData, imageBaseUrl } = props

  const handleOpenPlayerProfile = (user_id: number) => {
    window.location.href = `/player?id=${user_id}`
  }

  const getPlayerName = (data: PlayerLeaderBoard) => {
    let playerName = '-'

    if (data.username) {
      playerName = data.username
    } else if (data.useremail) {
      playerName = data.useremail.split('@')[0]
    }

    return playerName
  }

  return (
    <Paper sx={{ backgroundColor: '#212B36', borderRadius: 4 }}>
      <Typography variant="body2" sx={{ p: 2, color: '#fff' }}>
        {'Player Leaderboard'}
      </Typography>
      <TableContainer
        component={Paper}
        sx={{ backgroundColor: '#212B36', boxShadow: 'none' }}
        style={{ minHeight: '350px', maxHeight: '350px' }}
      >
        <Table aria-label="simple table" stickyHeader>
          <TableHead sx={{ color: '#fff' }}>
            <TableRow>
              {tableHeads.map((label, index) => (
                <TableCell
                  key={index}
                  align="left"
                  sx={{
                    color: '#818E9A !important',
                    borderColor: '#333D49',
                    backgroundColor: '#333D49',
                    py: 1,
                  }}
                >
                  {label}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>

          <TableBody>
            {leaderBoardData.length ? (
              leaderBoardData.map((row, index) => (
                <TableRow key={index}>
                  <TableCell
                    sx={{
                      color: '#fff',
                      borderColor: '#333D49',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'flex-start',
                      gap: 1,
                    }}
                  >
                    {row.avatar && (
                      <Box
                        position={'relative'}
                        width={46}
                        height={45}
                        sx={{ cursor: 'pointer' }}
                        onClick={() => handleOpenPlayerProfile(row?.id)}
                      >
                        <Box
                          component={'img'}
                          width={'100%'}
                          src={'/images/frobot_bg.png'}
                          boxShadow={'none'}
                        />
                        <Box
                          sx={{ transform: 'translate(-50%, -50%)' }}
                          top={'50%'}
                          left={'50%'}
                          zIndex={1}
                          position={'absolute'}
                          component={'img'}
                          width={'90%'}
                          height={'90%'}
                          src={`${imageBaseUrl}${row.avatar}`}
                        />
                      </Box>
                    )}
                    {getPlayerName(row)}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.frobot_count}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.xp}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.matches_won} / {row.matches_participated}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.rank}
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <EmptyTableData />
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </Paper>
  )
}
