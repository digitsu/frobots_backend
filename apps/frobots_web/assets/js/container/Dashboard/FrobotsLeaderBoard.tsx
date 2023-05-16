import React, { useCallback } from 'react'
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

const tableHeads = ['Frobot', 'Player', 'XP', 'Wins', 'Points']

interface FrobotLeaderBoard {
  attempts: number
  avatar: string
  frobot: string
  frobot_id: number
  matches_participated: number
  matches_won: number
  points: number
  username: string
  useremail: string
  xp: number
}

interface LeaderBoardProps {
  leaderBoardData: FrobotLeaderBoard[]
  imageBaseUrl: string
}

export default (props: LeaderBoardProps) => {
  const { leaderBoardData, imageBaseUrl } = props

  const handleOpenFrobotDetails = (frobot_id: number) => {
    window.location.href = `/garage/frobot?id=${frobot_id}`
  }

  const getPlayerName = (data: FrobotLeaderBoard) => {
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
        {'Frobots Leaderboard'}
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
                        onClick={() => handleOpenFrobotDetails(row.frobot_id)}
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
                    {row.frobot}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {getPlayerName(row)}
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
                    {row.matches_won}
                  </TableCell>
                  <TableCell
                    sx={{ color: '#fff', borderColor: '#333D49' }}
                    align="left"
                  >
                    {row.points}
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
