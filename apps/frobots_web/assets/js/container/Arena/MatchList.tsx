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
  TablePagination,
  TableRow,
  Typography,
} from '@mui/material'
import moment from 'moment'

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

const getHostName = (user: any) => {
  let hostName = '-'

  if (user?.name) {
    hostName = user.name
  } else if (user?.email) {
    hostName = user.email.split('@')[0]
  }

  return hostName
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
                Host
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
              <TableCell
                align="left"
                sx={{
                  color: '#DAD8CF !important',
                  borderColor: '#333D49',
                  backgroundColor: '#333D49',
                  py: 1,
                }}
              >
                Actions
              </TableCell>
            </TableRow>
          </TableHead>
          <TableBody sx={{ color: '#fff' }}>
            {matches?.length === 0 && (
              <TableRow>
                <TableCell>No Matches Found</TableCell>
              </TableRow>
            )}

            {matches.map((match) => {
              return (
                <TableRow hover key={match.id}>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.id}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    <Stack alignItems="center" direction="row" spacing={1}>
                      {match.title}
                    </Stack>
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {getHostName(match.user)}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {getStatus(match.status)}
                  </TableCell>
                  <TableCell sx={{ color: '#fff' }}>
                    {moment(match.match_time).format('DD MMM YYYY HH:mm:ss')}
                  </TableCell>
                  <TableCell
                    sx={{
                      color: '#fff',
                      display: 'flex',
                      justifyContent: 'space-around',
                    }}
                  >
                    {match.status !== 'done' ? (
                      <>
                        <Button
                          disabled={match.status === 'cancelled'}
                          href={`/arena/${match.id}`}
                          variant="outlined"
                          size="medium"
                          sx={{
                            color: '#00B8D9',
                            borderColor: '#00B8D9',
                            padding: '0px 25px',
                          }}
                        >
                          Join
                        </Button>
                        {
                          <Button
                            disabled={
                              match.status === 'cancelled' ||
                              match.status === 'pending'
                            }
                            href={`/arena/${match.id}/simulation`}
                            variant="outlined"
                            size="medium"
                            sx={{
                              color: '#00B8D9',
                              borderColor: '#00B8D9',
                              padding: '0px 25px',
                            }}
                          >
                            Watch
                          </Button>
                        }
                      </>
                    ) : (
                      <>
                        <Button
                          href={`/arena/${match.id}/replay`}
                          variant="outlined"
                          size="medium"
                          sx={{
                            color: '#00B8D9',
                            borderColor: '#00B8D9',
                            padding: '0px 18px',
                          }}
                        >
                          Replay
                        </Button>
                        <Button
                          target={'_blank'}
                          href={`/arena/${match.id}/results`}
                          disabled={match.status === 'cancelled'}
                          variant="outlined"
                          size="medium"
                          sx={{
                            color: '#00B8D9',
                            borderColor: '#00B8D9',
                            padding: '0px 18px',
                          }}
                        >
                          Results
                        </Button>
                      </>
                    )}
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
