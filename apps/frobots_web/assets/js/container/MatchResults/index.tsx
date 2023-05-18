import { Grid, Typography, Box } from '@mui/material'
import React from 'react'
import ResultItem from './ResultItem'
export default (props) => {
  const { match_results, s3_base_Url } = props
  return (
    <Box width={'90%'} m={'auto'} mt={8}>
      {match_results.length === 0 ? (
        <Grid
          container
          justifyContent={'center'}
          alignItems={'center'}
          minHeight={'calc(100vh - 50%)'}
        >
          <Grid item>
            <Box>
              <Typography variant="h3">Match ended with no results.</Typography>
            </Box>
          </Grid>
        </Grid>
      ) : (
        <Grid container spacing={2}>
          {match_results?.map(
            ({ frobot, health, kills, xp_earned, user_name, winner }) => (
              <Grid item xs={12}>
                <ResultItem
                  key={frobot.id}
                  frobot={frobot}
                  health={health}
                  kills={kills}
                  xp_earned={xp_earned}
                  user_name={user_name}
                  winner={winner}
                  s3_base_Url={s3_base_Url}
                />
              </Grid>
            )
          )}
        </Grid>
      )}
    </Box>
  )
}
