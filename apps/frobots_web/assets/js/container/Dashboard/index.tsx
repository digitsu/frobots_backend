import React, { useCallback, type MouseEvent } from 'react'
import { Grid, Box, Typography, Card } from '@mui/material'
import FrobotsLeaderBoard from './FrobotsLeaderBoard'
import PlayerLeaderBoard from './PlayerLeaderBoard'
import GlobalStats from './GlobalStats'
import Notifications from './Notifications'
import FeaturedFrobotSection from './FeaturedFrobotSection'
import ProfileDetails from './ProfileDetails'
import JoinMatchBanner from './JoinMatchBanner'
import NewsAndUpdatesSection from './NewsAndUpdatesSection'

export default (props: any) => {
  const {
    playerStats,
    globalStats,
    current_user_ranking_details,
    current_user_name,
    current_user_avatar,
    current_user_sparks,
    blogPosts,
    featuredFrobots,
    frobot_leaderboard_stats,
    player_leaderboard_stats,
  } = props

  const handleOpenGarage = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/garage'
    },
    []
  )

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
                      <Typography variant="h6">
                        {current_user_ranking_details?.rank || 0}
                      </Typography>
                      <Typography variant="caption">
                        Total XP : {playerStats.total_xp}
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
                  <Box display={'flex'} gap={3} onClick={handleOpenGarage}>
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
                      <Typography variant="h6">
                        {current_user_sparks || 0}
                      </Typography>
                      <Typography variant="caption">Total Sparks</Typography>
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
                      <Typography variant="h6">
                        {playerStats.matches_participated}
                      </Typography>
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
                      <Typography variant="h6">
                        {playerStats.upcoming_matches}
                      </Typography>
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
              <ProfileDetails
                ranking_details={current_user_ranking_details}
                user_name={current_user_name}
                user_avatar={current_user_avatar}
              />
              <Box>
                <GlobalStats globalStats={globalStats} />
              </Box>
            </Box>
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <FrobotsLeaderBoard leaderBoardData={frobot_leaderboard_stats} />
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <PlayerLeaderBoard leaderBoardData={player_leaderboard_stats} />
          </Grid>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <Notifications />
          </Grid>
        </Grid>
      </Box>
      <Box>
        <Grid container spacing={2} my={2}>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <FeaturedFrobotSection featuredFrobots={featuredFrobots} />
          </Grid>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <JoinMatchBanner />
          </Grid>
        </Grid>
      </Box>
      <Box width={'90%'} m={'auto'}>
        <Grid container spacing={2} my={2}>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <NewsAndUpdatesSection blogPosts={blogPosts} />
          </Grid>
        </Grid>
      </Box>
    </>
  )
}
