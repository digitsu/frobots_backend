import React, { useCallback, type ChangeEvent, type MouseEvent } from 'react'
import { Grid, Box, Typography, CardContent, Card } from '@mui/material'
import { MatchList } from './MatchList'
import { MatchListSearch } from './MatchListSearch'

export default (props: any) => {
  const {
    frobotDetails,
    battles,
    total_entries,
    updateBattleSearch,
    page,
    page_size,
    match_status,
  } = props

  const handleTabsChange = useCallback(
    (tab?: string): void => {
      updateBattleSearch({
        frobot_id: frobotDetails.frobot_id,
        match_status: tab,
        page: page,
        page_size: page_size,
      })
    },
    [updateBattleSearch]
  )

  const handlePageChange = useCallback(
    (event: MouseEvent<HTMLButtonElement> | null, pageCount: number): void => {
      updateBattleSearch({
        frobot_id: frobotDetails.frobot_id,
        match_status: match_status,
        page: pageCount + 1,
        page_size: page_size,
      })
    },
    [updateBattleSearch]
  )

  const handleRowsPerPageChange = useCallback(
    (event: ChangeEvent<HTMLInputElement>): void => {
      updateBattleSearch({
        frobot_id: frobotDetails.frobot_id,
        match_status: match_status,
        page: page,
        page_size: parseInt(event.target.value, 10),
      })
    },
    [updateBattleSearch]
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
                  <MatchListSearch onTabChange={handleTabsChange} />
                </CardContent>
                <CardContent>
                  <MatchList
                    matches={battles}
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
