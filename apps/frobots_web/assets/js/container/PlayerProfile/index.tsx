import React, { useState } from 'react'
import { Box, Card, Grid, Typography } from '@mui/material'
import ProfileDetails from './ProfileDetails'
import FrobotList from './FrobotList'

interface PlayerProfileProps {
  user: any
  user_name: string
  player_status: any
  s3_base_url: string
  user_frobots: any[]
}

export default (props: PlayerProfileProps) => {
  const { user, user_name, s3_base_url, user_frobots, player_status } = props

  return (
    <Box paddingBottom={3} width={'90%'} m={'auto'}>
      <Grid container spacing={2}>
        <Grid item xl={12} lg={12} md={12} sm={12} xs={12}>
          <ProfileDetails
            user_name={user_name}
            user_avatar={`${s3_base_url}${user.avatar}`}
            ranking_details={player_status}
            frobotsCount={user_frobots.length}
          />
        </Grid>
        <Grid item xl={12} lg={12} md={12} sm={12} xs={12}>
          <Typography variant="body1" marginBottom={2}>
            Frobots
          </Typography>
          <FrobotList s3BaseUrl={s3_base_url} userFrobots={user_frobots} />
        </Grid>
      </Grid>
    </Box>
  )
}
