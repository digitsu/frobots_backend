import React, { useCallback, type ChangeEvent, type MouseEvent } from 'react'
import { Grid, Box, Typography, CardContent } from '@mui/material'
import Card from '../../components/generic/Card'
import { MatchList } from './MatchList'
import { MatchListSearch } from './MatchListSearch'

export default (props: any) => {
  const {
    completed_matches_count,
    live_matches_count,
    upcoming_matches_count,
    total_entries,
    matches,
    updateMatchSearch,
    page,
    page_size,
    match_status,
    search_pattern,
  } = props

  const handleSearchChange = useCallback(
    (searchQuery?: string): void => {
      updateMatchSearch({
        match_status: match_status,
        search_pattern: searchQuery,
        page: page,
        page_size: page_size,
      })
    },
    [updateMatchSearch]
  )

  const handleTabsChange = useCallback(
    (tab?: string): void => {
      updateMatchSearch({
        match_status: tab,
        search_pattern: search_pattern,
        page: page,
        page_size: page_size,
      })
    },
    [updateMatchSearch]
  )

  const handlePageChange = useCallback(
    (event: MouseEvent<HTMLButtonElement> | null, pageCount: number): void => {
      updateMatchSearch({
        match_status: match_status,
        search_pattern: search_pattern,
        page: pageCount + 1,
        page_size: page_size,
      })
    },
    [updateMatchSearch]
  )

  const handleRowsPerPageChange = useCallback(
    (event: ChangeEvent<HTMLInputElement>): void => {
      updateMatchSearch({
        match_status: match_status,
        search_pattern: search_pattern,
        page: page,
        page_size: parseInt(event.target.value, 10),
      })
    },
    [updateMatchSearch]
  )

  const handleOpenLiveMatches = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/arena/running/matches'
    },
    []
  )

  const handleOpenPastMatches = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/arena/done/matches'
    },
    []
  )

  const handleOpenUpcomingMatches = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/arena/pending/matches'
    },
    []
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
                  <Box
                    display={'flex'}
                    gap={3}
                    onClick={handleOpenLiveMatches}
                    sx={{ cursor: 'pointer' }}
                  >
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
                        {live_matches_count || 0}
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
                  <Box
                    display={'flex'}
                    gap={3}
                    onClick={handleOpenUpcomingMatches}
                    sx={{ cursor: 'pointer' }}
                  >
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
                        {upcoming_matches_count || 0}
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
                  <Box
                    display={'flex'}
                    gap={3}
                    onClick={handleOpenPastMatches}
                    sx={{ cursor: 'pointer' }}
                  >
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
                        {completed_matches_count || 0}
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
                  <MatchListSearch
                    onQueryChange={handleSearchChange}
                    onTabChange={handleTabsChange}
                  />
                </CardContent>
                <CardContent>
                  <MatchList
                    matches={matches}
                    matchesCount={total_entries}
                    page={page - 1}
                    rowsPerPage={page_size}
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
