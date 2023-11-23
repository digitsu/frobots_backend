import {
  Box,
  Card,
  Divider,
  Grid,
  TablePagination,
  TextField,
  Typography,
} from '@mui/material'
import { Stack } from '@mui/system'
import moment from 'moment'
import React, { useState } from 'react'
import { SeverityPill } from '../../components/generic/SeverityPill'
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth'
import { formatEpochDateTime } from '../../utils/util'

type Order = 'asc' | 'desc'

type TournamentData = {
  arena_fees_percent: number
  arena_id: number
  description: string
  id: number
  name: string
  starts_at: EpochTimeStamp
  status: string
}

export default ({ tournaments, imageBaseUrl, arenas }) => {
  const [order, setOrder] = useState<Order>('desc')
  const [orderBy, setOrderBy] = useState<keyof TournamentData>('starts_at')
  const [page, setPage] = useState(0)
  const [rowsPerPage, setRowsPerPage] = useState(5)
  const getArenaImage = (arena_id) => {
    return `${imageBaseUrl}${
      arenas.find(({ id }) => id === arena_id).image_url
    }`
  }
  const [tournamentsList, setTournamentsList] = useState(tournaments)
  const statuses = {
    inprogress: 'warning',
    open: 'secondary',
    completed: 'primary',
    cancelled: 'error',
  }

  const findTournaments = (query) => {
    const filterList = tournaments.filter(
      ({ id, name }) =>
        id == query || name.toLowerCase().includes(query.toLowerCase())
    )
    setTournamentsList(filterList)
  }

  function stableSort<T>(
    array: readonly T[],
    comparator: (a: T, b: T) => number
  ) {
    const stabilizedThis = array.map((el, index) => [el, index] as [T, number])
    stabilizedThis.sort((a, b) => {
      const order = comparator(a[0], b[0])
      if (order !== 0) {
        return order
      }
      return a[1] - b[1]
    })
    return stabilizedThis.map((el) => el[0])
  }

  function getComparator<Key extends keyof any>(
    order: string,
    orderBy: Key
  ): (
    a: { [key in Key]: number | string },
    b: { [key in Key]: number | string }
  ) => number {
    return order === 'desc'
      ? (a, b) => descendingComparator(a, b, orderBy)
      : (a, b) => -descendingComparator(a, b, orderBy)
  }

  function descendingComparator<T>(a: T, b: T, orderBy: keyof T) {
    if (b[orderBy] < a[orderBy]) {
      return -1
    }
    if (b[orderBy] > a[orderBy]) {
      return 1
    }
    return 0
  }

  const handleChangePage = (event: unknown, newPage: number) => {
    setPage(newPage)
  }

  const handleChangeRowsPerPage = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setRowsPerPage(parseInt(event.target.value, 10))
    setPage(0)
  }

  return (
    <Box>
      <Box my={2} display={'flex'} justifyContent={'flex-end'}>
        <TextField
          size="small"
          variant="outlined"
          placeholder={'Search by Id or Name'}
          onChange={(evt) => findTournaments(evt.target.value)}
          sx={{ fontSize: 14 }}
        />
      </Box>
      <Grid container spacing={1}>
        {stableSort(tournamentsList, getComparator(order, orderBy))
          .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
          .map((tournament) => (
            <Grid
              item
              md={12}
              sx={{
                '&:hover': {
                  cursor: 'pointer',
                },
              }}
            >
              <a href={`/tournaments/${tournament.id}`}>
                <Card sx={{ p: 1.5, background: 'transparent' }}>
                  <Stack
                    direction={'row'}
                    alignItems={'center'}
                    justifyContent={'space-between'}
                    position={'relative'}
                    gap={2}
                  >
                    <Stack
                      direction={'row'}
                      alignItems={'center'}
                      justifyContent={'flex-start'}
                      gap={2}
                    >
                      <Box
                        component={'img'}
                        width={100}
                        height={100}
                        src={getArenaImage(tournament.arena_id)}
                      />
                      <Box>
                        <Typography variant="subtitle1" sx={{ mb: 1 }}>
                          {tournament.name}
                        </Typography>
                        <Box display={'flex'} gap={0.5}>
                          <CalendarMonthIcon fontSize={'small'} />
                          {(() => {
                            const { day, month, year, time } =
                              formatEpochDateTime(tournament.starts_at)

                            return (
                              <Stack
                                direction={'row'}
                                gap={1}
                                divider={<Divider orientation="vertical" />}
                              >
                                <Stack
                                  direction={'row'}
                                  alignItems={'center'}
                                  justifyContent={'space-between'}
                                  gap={0.5}
                                >
                                  <Typography
                                    variant="subtitle2"
                                    textAlign={'center'}
                                  >
                                    {day}
                                  </Typography>
                                  <Typography
                                    variant="body2"
                                    textTransform={'uppercase'}
                                    textAlign={'center'}
                                  >
                                    {month}
                                  </Typography>
                                  <Typography
                                    variant="subtitle2"
                                    textAlign={'center'}
                                  >
                                    {year}
                                  </Typography>
                                </Stack>
                                <Stack>
                                  <Typography
                                    variant="body2"
                                    textTransform={'uppercase'}
                                    textAlign={'center'}
                                  >
                                    {time}
                                  </Typography>
                                </Stack>
                              </Stack>
                            )
                          })()}
                        </Box>
                      </Box>
                    </Stack>
                    <Box>
                      <SeverityPill
                        color={statuses[tournament.status] || 'success'}
                      >
                        {tournament.status}
                      </SeverityPill>
                    </Box>
                  </Stack>
                </Card>
              </a>
            </Grid>
          ))}
        <Box width={'100%'} display={'flex'} justifyContent={'flex-end'} mt={2}>
          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={tournamentsList.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onPageChange={handleChangePage}
            onRowsPerPageChange={handleChangeRowsPerPage}
            sx={{ border: 'none' }}
          />
        </Box>
      </Grid>
    </Box>
  )
}
