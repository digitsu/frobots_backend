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
    winner: 'TBD',
    xp: 'TBD',
    status: 'live',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3153',
    name: 'Battle 7',
    winner: 'TBD',
    xp: 'TBD',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e315e',
    name: 'Battle 3',
    winner: 'Kakashi Hatake',
    xp: '+50',
    status: 'lost',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3146',
    name: 'Battle 7',
    winner: 'Kaztro',
    xp: '+5000',
    status: 'won',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3156',
    name: 'Battle 9',
    winner: 'Satoru Gojo',
    xp: '+5000',
    status: 'won',
    time: '21th March 2023 20:00:00',
  },
  {
    matchId: '7f54cf1e325j',
    name: 'Battle 2',
    winner: 'Kaztro',
    xp: '+20000',
    status: 'won',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '3f54cf1e315e',
    name: 'Battle 12',
    winner: 'TBD',
    xp: 'TBD',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: 'Lf54cf1e315d',
    name: 'Battle 7',
    winner: 'Kaztro',
    xp: '+0',
    status: 'lost',
    time: '20th Feb 2022 20:00:00',
  },
]
interface Filters {
  query?: string
  isUpcoming?: boolean
  isLive?: boolean
  isLost?: boolean
  isWon?: boolean
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
        const properties: ('winner' | 'name' | 'status')[] = [
          'winner',
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

      if (typeof filters.isUpcoming !== 'undefined') {
        if (match.status !== 'upcoming') {
          return false
        }
      }

      if (typeof filters.isLive !== 'undefined') {
        if (match.status !== 'live') {
          return false
        }
      }

      if (typeof filters.isWon !== 'undefined') {
        if (match.status !== 'won') {
          return false
        }
      }

      if (typeof filters.isLost !== 'undefined') {
        if (match.status !== 'lost') {
          return false
        }
      }
      if (typeof filters.isCompleted !== 'undefined') {
        if (match.status == 'live' || match.status == 'upcoming') {
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
      isLost: undefined,
      isLive: undefined,
      isWon: undefined,
      isUpcoming: undefined,
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

const useMatches = (search: Search): { matchs: any[] } => {
  const [state, setState] = useState<{
    matchs: any[]
  }>({
    matchs: [],
  })

  const getMatches = useCallback(async () => {
    try {
      const response = getMatchesAPI(search)

      setState({
        matchs: response.data,
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
  const { matchs } = useMatches(search)

  const handleFiltersChange = useCallback(
    (filters: Filters): void => {
      updateSearch((prevState) => ({
        ...prevState,
        filters,
      }))
    },
    [updateSearch]
  )

  return (
    <>
      <Box width={'100%'} m={'auto'} pb={2}>
        <Grid container spacing={2}>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <Typography
              sx={{ pl: 0, mt: 1, mb: 2 }}
              variant={'subtitle1'}
              fontWeight={'bold'}
            >
              Battles
            </Typography>
            <Box>
              <Card>
                <CardContent>
                  <MatchListSearch onFiltersChange={handleFiltersChange} />
                </CardContent>
                <CardContent>
                  <MatchList matchs={matchs} />
                </CardContent>
              </Card>
            </Box>
          </Grid>
        </Grid>
      </Box>
    </>
  )
}
