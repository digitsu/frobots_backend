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
  attempts: string
  avatar: string
  frobots_count: number
  matches_participated: number
  matches_won: string
  points: number
  rank: number
  username: 'God'
  xp: number
}

interface LeaderBoardProps {
  leaderBoardData: PlayerLeaderBoard[]
  imageBaseUrl: string
}

export default (props: LeaderBoardProps) => {
  const { leaderBoardData, imageBaseUrl } = props

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
                        width={100}
                        height={100}
                        sx={{ cursor: 'pointer', p: 1 }}
                      >
                        <Box
                          component={'img'}
                          width={'100%'}
                          src={'/images/frobot_bg.png'}
                          sx={{
                            boxShadow: 'none',
                            borderRadius: '6px',
                          }}
                        ></Box>
                        <Box
                          sx={{ transform: 'translate(-50%, -50%)' }}
                          top={'50%'}
                          left={'50%'}
                          zIndex={1}
                          position={'absolute'}
                          component={'img'}
                          width={'100%'}
                          height={'100%'}
                          src={`${imageBaseUrl}${row.avatar}`}
                        />
                      </Box>
                    )}
                    {row.username}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.frobots_count}
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
