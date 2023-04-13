import React, { FC, type ChangeEvent, type MouseEvent } from 'react'
import PropTypes from 'prop-types'
import {
  Box,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TablePagination,
  TableRow,
  Typography,
} from '@mui/material'
import moment from 'moment'
import EmptyTableData from '../../components/generic/EmptyTableData'

interface MatchListTableProps {
  matches: any[]
  matchesCount: number
  onPageChange: (
    event: MouseEvent<HTMLButtonElement> | null,
    newPage: number
  ) => void
  onRowsPerPageChange?: (event: ChangeEvent<HTMLInputElement>) => void
  page: number
  rowsPerPage: number
}

const getStatus = (status: string) => {
  const statusColors = {
    running: '#37A6E4',
    pending: '#FFD600',
    done: '#5BE584',
    cancelled: '#FF5630',
    timeout: '#FF5630',
  }

  const statusName = {
    running: 'live',
    pending: 'upcoming',
    done: 'completed',
    cancelled: 'cancelled',
    timeout: 'timeout',
  }

  return (
    <Typography
      color={statusColors[status] || 'gray'}
      sx={{ textTransform: 'capitalize' }}
    >
      {statusName[status]}
    </Typography>
  )
}

export const MatchList: FC<MatchListTableProps> = (props) => {
  const {
    matches,
    matchesCount,
    onPageChange,
    onRowsPerPageChange,
    page,
    rowsPerPage,
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
            {matches?.length === 0 && <EmptyTableData />}

            {matches.map((match) => {
              return (
                <TableRow hover key={match.match_id}>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.match_id}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.match_name}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {match.winner || '-'}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>{match.xp}</TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {getStatus(match.status)}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {moment(match.match_time).format('DD MMM YYYY HH:mm:ss')}
                  </TableCell>
                </TableRow>
              )
            })}
          </TableBody>
        </Table>
      </TableContainer>
      <TablePagination
        component="div"
        count={matchesCount}
        onPageChange={onPageChange}
        onRowsPerPageChange={onRowsPerPageChange}
        page={page}
        rowsPerPage={rowsPerPage}
        rowsPerPageOptions={[5, 10, 25]}
        sx={{ color: '#fff' }}
      />
    </Box>
  )
}

MatchList.propTypes = {
  matches: PropTypes.any,
  matchesCount: PropTypes.number.isRequired,
  onPageChange: PropTypes.func.isRequired,
  onRowsPerPageChange: PropTypes.func,
  page: PropTypes.number.isRequired,
  rowsPerPage: PropTypes.number.isRequired,
}
