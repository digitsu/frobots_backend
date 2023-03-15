import React, { FC, type ChangeEvent, type MouseEvent } from 'react'
import PropTypes from 'prop-types'
import {
  Box,
  Button,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'

interface MatchListTableProps {
  matchs: any[]
}

const getStatusName = (status: string) => {
  const statusColors = {
    live: '#37A6E4',
    upcoming: '#FFD600',
    won: '#5BE584',
    lost: '#FF5630',
  }

  return (
    <Typography
      color={statusColors[status] || 'gray'}
      sx={{ textTransform: 'capitalize' }}
    >
      {status}
    </Typography>
  )
}

export const MatchList: FC<MatchListTableProps> = (props) => {
  const {
    matchs,
    ...other
  } = props

  return (
    <Box sx={{ position: 'relative' }} {...other}>
      <TableContainer
        sx={{
          maxHeight: 320,
          minHeight: 320,
          backgroundColor: '#212B36',
          boxShadow: 'none',
        }}
      >
        <Table
          aria-label="simple table"
          sx={{ minWidth: 500 }}
          stickyHeader={true}
        >
          <TableHead sx={{ color: '#fff' }}>
            <TableRow>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Match ID
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Match Name
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Winner
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                XP
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Status
              </TableCell>
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Time
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody sx={{ color: '#fff' }}>
            {matchs?.length === 0 && (
              <TableRow>
                <TableCell>No Data Found</TableCell>
              </TableRow>
            )}

            {matchs.map((match) => {
              return (
                <TableRow hover key={match.matchId}>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.matchId}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.name}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>{match.winner}</TableCell>
                  <TableCell sx={{ color: '#fff' }}>{match.xp}</TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {getStatusName(match.status)}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>{match.time}</TableCell>
                </TableRow>
              )
            })}
          </TableBody>
        </Table>
      </TableContainer>
      <Box px={2} py={1}>
        <ViewMore label={'View More'} />
      </Box>
    </Box>
  )
}

MatchList.propTypes = {
  matchs: PropTypes.any,
}
