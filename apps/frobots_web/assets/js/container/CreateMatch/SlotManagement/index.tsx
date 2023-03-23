import { Grid, Typography, Box } from '@mui/material'
import React from 'react'
import SlotContainer from './SlotContainer'
import SlotDetails from './SlotDetails'

export default () => {
  return (
    <Box my={2}>
      <Grid
        container
        spacing={2}
        alignSelf={'stretch'}
        sx={{ width: '90%', m: 'auto' }}
      >
        <Grid item md={12} lg={6}>
          <SlotContainer />
        </Grid>
        <Grid item md={12} lg={6}>
          <SlotDetails />
        </Grid>
      </Grid>
    </Box>
  )
}
