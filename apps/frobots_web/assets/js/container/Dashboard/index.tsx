import React from 'react'
import { Grid, Box, Typography, Card } from '@mui/material'
import FrobotsLeaderBoard from './FrobotsLeaderBoard'
import PlayerLeaderBoard from './PlayerLeaderBoard'
import GlobalStats from './GlobalStats'
import Notifications from './Notifications'
import FeaturedFrobotSection from './FeaturedFrobotSection'
import ProfileDetails from './ProfileDetails'
import JoinMatchBanner from './JoinMatchBanner'
import NewsAndUpdatesSection from './NewsAndUpdatesSection'
export default () => {
  return (
    <>
      <Box width={'90%'} m={'auto'}>
        <Grid container spacing={2}>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <Box
              display={'flex'}
              gap={2}
              flexDirection={'column'}
              height={'100%'}
            >
              <Card>
                <Box
                  height={240}
                  p={5}
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                  position={'relative'}
                >
                  <Box display={'flex'} gap={3}>
                    <Box
                      component={'img'}
                      src={'/images/ranking.svg'}
                      width={75}
                    />

                    <Box
                      display={'flex'}
                      justifyContent={'center'}
                      flexDirection={'column'}
                    >
                      <Typography variant="h6">12378</Typography>
                      <Typography variant="caption">
                        Total XP : 975610
                      </Typography>
                    </Box>
                  </Box>

                  <Box
                    display={'flex'}
                    sx={{
                      height: '100%',
                      position: 'absolute',
                      left: '50%',
                      borderRight: 1,
                      borderColor: 'rgba(145, 158, 171, 0.24)',
                      borderStyle: 'dotted',
                    }}
                  />
                  <Box display={'flex'} gap={3}>
                    <Box
                      component={'img'}
                      src={'/images/frobot.svg'}
                      width={75}
                    />
                    <Box
                      display={'flex'}
                      justifyContent={'center'}
                      flexDirection={'column'}
                    >
                      <Typography variant="h6">7</Typography>
                      <Typography variant="caption">
                        Sparkling Frobots
                      </Typography>
                    </Box>
                  </Box>
                </Box>
              </Card>
              <Card>
                <Box
                  height={240}
                  p={5}
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
                      <Typography variant="h6">635</Typography>
                      <Typography variant="caption">
                        Total Matches Played
                      </Typography>
                    </Box>
                  </Box>
                  <Box
                    display={'flex'}
                    sx={{
                      height: '100%',
                      position: 'absolute',
                      left: '50%',
                      borderRight: 1,
                      borderColor: 'rgba(145, 158, 171, 0.24)',
                      borderStyle: 'dotted',
                    }}
                  />
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
                      <Typography variant="h6">13</Typography>
                      <Typography variant="caption">
                        Upcoming Matches
                      </Typography>
                    </Box>
                  </Box>
                </Box>
              </Card>
            </Box>
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <Box
              display={'flex'}
              gap={2}
              flexDirection={'column'}
              height={'100%'}
            >
              <ProfileDetails />
              <Box>
                <GlobalStats />
              </Box>
            </Box>
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <FrobotsLeaderBoard />
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <PlayerLeaderBoard />
          </Grid>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <Notifications />
          </Grid>
        </Grid>
      </Box>
      <Box>
        <Grid container spacing={2} my={2}>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <FeaturedFrobotSection />
          </Grid>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <JoinMatchBanner />
          </Grid>
        </Grid>
      </Box>
      <Box width={'90%'} m={'auto'}>
        <NewsAndUpdatesSection />
      </Box>
    </>
  )
}
