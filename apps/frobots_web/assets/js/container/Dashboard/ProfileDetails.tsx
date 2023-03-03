import React from 'react'
import { Box, Grid, Typography } from '@mui/material'
import Card from '../../components/generic/Card'
export default () => {
  return (
    <Card>
      <Box p={3} height={240}>
        <Grid container spacing={1}>
          <Grid item xs={9} sm={9} md={9} lg={9}>
            <Box mt={2}>
              {' '}
              <Typography variant="h6">DJC</Typography>
              <Box display={'flex'} flexDirection={'column'} gap={1} mt={1}>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                >
                  <Typography flex={2} variant="caption">
                    Ranking
                  </Typography>
                  <Typography flex={1} variant="caption">
                    :
                  </Typography>
                  <Typography flex={2} variant="caption">
                    #46
                  </Typography>
                </Box>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                >
                  <Typography flex={2} variant="caption">
                    Wins
                  </Typography>
                  <Typography flex={1} variant="caption">
                    :
                  </Typography>
                  <Typography flex={2} variant="caption">
                    193/200
                  </Typography>
                </Box>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                >
                  <Typography flex={2} variant="caption">
                    Total XP
                  </Typography>
                  <Typography flex={1} variant="caption">
                    :
                  </Typography>
                  <Typography flex={2} variant="caption">
                    12312346 XP
                  </Typography>
                </Box>
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                >
                  <Typography flex={2} variant="caption">
                    QDOS Earned
                  </Typography>
                  <Typography flex={1} variant="caption">
                    :
                  </Typography>
                  <Typography flex={2} variant="caption">
                    312346 Q
                  </Typography>
                </Box>
              </Box>
            </Box>
          </Grid>
          <Grid item xs={3} sm={3} md={3} lg={3}>
            <Box
              margin={'auto'}
              src={'/images/user_logo.png'}
              component={'img'}
            />
          </Grid>
        </Grid>
      </Box>
    </Card>
  )
}
