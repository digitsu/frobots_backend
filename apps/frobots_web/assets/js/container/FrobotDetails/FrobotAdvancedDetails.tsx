import React from 'react'
import { Grid, Card, Box, Typography } from '@mui/material'

interface AdvancedDetailsProps {
  frobotDetails: any
  isOwnedFrobot: boolean
  xFrameDetails: any
}

export default (props: AdvancedDetailsProps) => {
  const { frobotDetails, xFrameDetails } = props
  return (
    <Grid item lg={4} md={6} sm={6} xs={12}>
      <Card
        sx={{
          bgcolor: '#212B36',
          borderRadius: 4,
          overflowY: 'scroll',
          p: 4,
          height: '100%',
        }}
      >
        <Box
          display={'flex'}
          alignItems={'center'}
          justifyContent={'flex-start'}
          gap={1}
          mb={3}
        >
          {' '}
          <Typography variant="h3">{frobotDetails.xp || 0}</Typography>
          <Typography variant="h5" fontWeight={'light'}>
            XP
          </Typography>
        </Box>
        <Grid container spacing={3}>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Ranking</Typography>
            <Typography variant="body2">
              {frobotDetails.ranking || 0}
            </Typography>
          </Grid>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Health</Typography>

            <Typography variant="body2">
              {' '}
              {xFrameDetails?.health || 0} / {xFrameDetails?.max_health || 0} ap
            </Typography>
          </Grid>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Accel Speed</Typography>

            <Typography variant="body2">
              {xFrameDetails?.accel_speed_mss || 0} m/s^2
            </Typography>
          </Grid>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Max Speed</Typography>
            <Typography variant="body2">
              {' '}
              {xFrameDetails?.max_speed_ms || 0} m/s
            </Typography>
          </Grid>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Turn Speed</Typography>
            <Typography variant="body2">
              {' '}
              {xFrameDetails?.turn_speed || 0}%
            </Typography>
          </Grid>
          <Grid item xs={6} md={4}>
            <Typography variant="subtitle2">Max Throttle</Typography>
            <Typography variant="body2">
              {' '}
              {xFrameDetails?.max_throttle || 0}
            </Typography>
          </Grid>
        </Grid>
      </Card>
    </Grid>
  )
}
