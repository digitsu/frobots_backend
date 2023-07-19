import { Grid, Typography, Box, Card } from '@mui/material'
import React from 'react'
import ResultItem from './ResultItem'
export default (props) => {
  const { match_results, s3_base_Url } = props
  const statusObj = {
    cancelled: {
      label: 'Match Cancelled',
      background: 'linear-gradient(to right, #db042d, #ff6f6f)',
    },
    aborted: {
      label: 'Match Aborted',
      background: 'linear-gradient(to right, #f7501c, #f0967a)',
    },
    done: {
      label: 'Match Completed',
      background: 'linear-gradient(to right, #156c42, #60ffa2c7)',
    },
    timeout: {
      label: 'Match Timed Out',
      background: 'linear-gradient(to right,#ffc107,  #ffeb3b)',
    },
  }
  return (
    <>
      <Card
        sx={{
          mt: 3,
          p: 5,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          borderRadius: 0,
          background:
            statusObj[match_results?.status]?.background ||
            'linear-gradient(to right, #9e9e9e, #616161)',
        }}
      >
        <Typography variant="h5">
          {statusObj[match_results?.status]?.label || 'No Results'}
        </Typography>
      </Card>
      <Box width={'90%'} m={'auto'} mt={4}>
        {match_results.length === 0 ? (
          <Grid
            container
            justifyContent={'center'}
            alignItems={'center'}
            minHeight={'calc(100vh - 50%)'}
          >
            <Grid item>
              <Box>
                <Typography variant="h3">
                  Match ended with no results.
                </Typography>
              </Box>
            </Grid>
          </Grid>
        ) : (
          <Grid container spacing={2}>
            {match_results.frobots
              ?.filter(({ frobot }) => frobot !== null)
              ?.map(
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
    </>
  )
}
