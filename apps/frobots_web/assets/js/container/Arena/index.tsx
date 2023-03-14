import React, {
  useCallback,
  useEffect,
  useState,
  type ChangeEvent,
  type MouseEvent,
} from 'react'
import { Grid, Box, Typography, CardContent } from '@mui/material'
import Card from '../../components/generic/Card'
import { MatchList } from './MatchList'
import { MatchListSearch } from './MatchListSearch'

const matchesList = [
  {
    matchId: '7f54cf1e315d',
    name: 'Battle 7',
    host: 'Kaztro',
    status: 'live',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3153',
    name: 'Battle 7',
    host: 'Kaztro',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e315e',
    name: 'Battle 3',
    host: 'Kakashi Hatake',
    status: 'completed',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3146',
    name: 'Battle 7',
    host: 'Kaztro',
    status: 'live',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3156',
    name: 'Battle 9',
    host: 'Satoru Gojo',
    status: 'cancelled',
    time: '21th March 2023 20:00:00',
  },
  {
    matchId: '7f54cf1e325j',
    name: 'Battle 2',
    host: 'Kaztro',
    status: 'completed',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '3f54cf1e315e',
    name: 'Battle 12',
    host: 'Naruto',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: 'Lf54cf1e315d',
    name: 'Battle 7',
    host: 'Kaztro',
    status: 'live',
    time: '20th Feb 2022 20:00:00',
  },
]
interface Filters {
  query?: string
  isUpcoming?: boolean
  isLive?: boolean
  isCompleted?: boolean
}

interface Search {
  filters: Filters
  page: number
  rowsPerPage: number
}

export function applyPagination<T = any>(
  documents: T[],
  page: number,
  rowsPerPage: number
): T[] {
  return documents.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
}

const getMatchesAPI = (request: Search) => {
  const { filters, page, rowsPerPage } = request

  let data = matchesList
  let count = data.length

  if (typeof filters !== 'undefined') {
    data = matchesList.filter((match) => {
      if (typeof filters.query !== 'undefined' && filters.query !== '') {
        let queryMatched = false
        const properties: ('host' | 'name' | 'status')[] = [
          'host',
          'name',
          'status',
        ]

        properties.forEach((property) => {
          if (
            match[property].toLowerCase().includes(filters.query!.toLowerCase())
          ) {
            queryMatched = true
          }
        })

        if (!queryMatched) {
          return false
        }
      }

      if (typeof filters.isCompleted !== 'undefined') {
        if (match.status !== 'completed') {
          return false
        }
      }

      if (typeof filters.isLive !== 'undefined') {
        if (match.status !== 'live') {
          return false
        }
      }

      if (typeof filters.isUpcoming !== 'undefined') {
        if (match.status !== 'upcoming') {
          return false
        }
      }

      return true
    })

    count = data.length
  }

  if (typeof page !== 'undefined' && typeof rowsPerPage !== 'undefined') {
    data = applyPagination(data, page, rowsPerPage)
  }

  return {
    data,
    count,
  }
}

const useSearch = () => {
  const [search, setSearch] = useState<Search>({
    filters: {
      query: undefined,
      isUpcoming: undefined,
      isLive: undefined,
      isCompleted: undefined,
    },
    page: 0,
    rowsPerPage: 5,
  })

  return {
    search,
    updateSearch: setSearch,
  }
}

const useMatches = (search: Search): { matchs: any[]; matchsCount: number } => {
  const [state, setState] = useState<{
    matchs: any[]
    matchsCount: number
  }>({
    matchs: [],
    matchsCount: 0,
  })

  const getMatches = useCallback(async () => {
    try {
      const response = getMatchesAPI(search)

      setState({
        matchs: response.data,
        matchsCount: response.count,
      })
    } catch (err) {
      console.error(err)
    }
  }, [search])

  useEffect(() => {
    getMatches()
  }, [search, getMatches])

  return state
}

export default () => {
  const { search, updateSearch } = useSearch()
  const { matchs, matchsCount } = useMatches(search)

  const handleFiltersChange = useCallback(
    (filters: Filters): void => {
      updateSearch((prevState) => ({
        ...prevState,
        filters,
      }))
    },
    [updateSearch]
  )

  const handlePageChange = useCallback(
    (event: MouseEvent<HTMLButtonElement> | null, page: number): void => {
      updateSearch((prevState) => ({
        ...prevState,
        page,
      }))
    },
    [updateSearch]
  )

  const handleRowsPerPageChange = useCallback(
    (event: ChangeEvent<HTMLInputElement>): void => {
      updateSearch((prevState) => ({
        ...prevState,
        rowsPerPage: parseInt(event.target.value, 10),
      }))
    },
    [updateSearch]
  )

  return (
    <>
      <Box width={'90%'} m={'auto'}>
        <Grid container spacing={2}>
          <Grid item lg={3} md={12} sm={12} xs={12}>
            <Typography
              sx={{ pl: 0, mt: 1, mb: 2 }}
              variant={'subtitle1'}
              fontWeight={'bold'}
            >
              My Matches
            </Typography>
            <Box
              display={'flex'}
              gap={2}
              flexDirection={'column'}
              height={'100%'}
            >
              <Card>
                <Box
                  p={8}
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                  position={'relative'}
                >
                  <Box display={'flex'} gap={3}>
                    <Box
                      component={'img'}
                      src={'/images/stats.svg'}
                      width={75}
                    />
                    <Box
                      display={'flex'}
                      justifyContent={'center'}
                      flexDirection={'column'}
                    >
                      <Typography variant="h6" fontWeight={'bold'}>
                        12
                      </Typography>
                      <Typography variant="caption">Live Matches</Typography>
                    </Box>
                  </Box>
                </Box>

                <Box
                  display={'flex'}
                  sx={{
                    width: '100%',
                    position: 'relative',
                    borderBottom: 1,
                    borderColor: 'rgba(145, 158, 171, 0.24)',
                    borderStyle: 'dotted',
                  }}
                />

                <Box
                  p={8}
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                  position={'relative'}
                >
                  <Box display={'flex'} gap={3}>
                    <Box
                      component={'img'}
                      src={'/images/calendar.svg'}
                      width={75}
                    />
                    <Box
                      display={'flex'}
                      justifyContent={'center'}
                      flexDirection={'column'}
                    >
                      <Typography variant="h6" fontWeight={'bold'}>
                        12
                      </Typography>
                      <Typography variant="caption">
                        Upcoming Matches
                      </Typography>
                    </Box>
                  </Box>
                </Box>

                <Box
                  display={'flex'}
                  sx={{
                    width: '100%',
                    position: 'relative',
                    borderBottom: 1,
                    borderColor: 'rgba(145, 158, 171, 0.24)',
                    borderStyle: 'dotted',
                  }}
                />

                <Box
                  p={8}
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                  position={'relative'}
                >
                  <Box display={'flex'} gap={3}>
                    <Box
                      component={'img'}
                      src={'/images/stats.svg'}
                      width={75}
                    />
                    <Box
                      display={'flex'}
                      justifyContent={'center'}
                      flexDirection={'column'}
                    >
                      <Typography variant="h6" fontWeight={'bold'}>
                        625
                      </Typography>
                      <Typography variant="caption">Past Matches</Typography>
                    </Box>
                  </Box>
                </Box>
              </Card>
            </Box>
          </Grid>
          <Grid item lg={9} md={12} sm={12} xs={12}>
            <Typography
              sx={{ pl: 0, mt: 1, mb: 2 }}
              variant={'subtitle1'}
              fontWeight={'bold'}
            >
              Explore Matches
            </Typography>
            <Box>
              <Card>
                <CardContent>
                  <MatchListSearch onFiltersChange={handleFiltersChange} />
                </CardContent>
                <CardContent>
                  <MatchList
                    matchs={matchs}
                    matchsCount={matchsCount}
                    page={search.page}
                    rowsPerPage={search.rowsPerPage}
                    onPageChange={handlePageChange}
                    onRowsPerPageChange={handleRowsPerPageChange}
                  />
                </CardContent>
              </Card>
            </Box>
          </Grid>
        </Grid>
      </Box>
    </>
  )
}
