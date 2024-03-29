import React, { useCallback, type MouseEvent } from 'react'
import { Grid, Box, Typography, Card, Tooltip } from '@mui/material'
import FrobotsLeaderBoard from './FrobotsLeaderBoard'
import PlayerLeaderBoard from './PlayerLeaderBoard'
import GlobalStats from './GlobalStats'
import Notifications from './Notifications'
import FeaturedFrobotSection from './FeaturedFrobotSection'
import ProfileDetails from './ProfileDetails'
import NewsAndUpdatesBanner from './NewsAndUpdatesBanner'

export default (props: any) => {
  const {
    playerStats,
    globalStats,
    current_user_ranking_details,
    current_user_name,
    current_user_avatar,
    current_user_sparks,
    featuredFrobots,
    frobot_leaderboard_stats,
    player_leaderboard_stats,
    s3_base_url,
    latestBlogPost,
  } = props

  const handleOpenGarage = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/garage'
    },
    []
  )

  const handleOpenArena = useCallback(
    (event: MouseEvent<HTMLDivElement> | null) => {
      event?.preventDefault()

      window.location.href = '/arena'
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
                  <Tooltip
                    title={'You earn XP by playing matches with your FROBOT.'}
                  >
                    <Box
                      display={'flex'}
                      gap={3}
                      onClick={handleOpenArena}
                      sx={{ cursor: 'pointer' }}
                    >
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
                  </Tooltip>
                  <Tooltip title={'Spark is needed to create new FROBOTs.'}>
                    <Box
                      display={'flex'}
                      gap={3}
                      onClick={handleOpenGarage}
                      sx={{ cursor: 'pointer' }}
                    >
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
                        <Typography variant="caption">
                          Sparks Available
                        </Typography>
                      </Box>
                    </Box>
                  </Tooltip>
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
                user_avatar={`${s3_base_url}${current_user_avatar}`}
              />

              <GlobalStats globalStats={globalStats} />
            </Box>
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <FrobotsLeaderBoard
              leaderBoardData={frobot_leaderboard_stats}
              imageBaseUrl={s3_base_url}
            />
          </Grid>
          <Grid item lg={6} md={12} sm={12} xs={12}>
            <PlayerLeaderBoard
              leaderBoardData={player_leaderboard_stats}
              imageBaseUrl={s3_base_url}
            />
          </Grid>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <Notifications />
          </Grid>
          {latestBlogPost && (
            <Grid item lg={12} md={12} sm={12} xs={12}>
              <NewsAndUpdatesBanner post={latestBlogPost} />
            </Grid>
          )}
        </Grid>
      </Box>
      <Box width={'90%'} m={'auto'} pb={4}>
        <Grid container spacing={2} my={2}>
          <Grid item lg={12} md={12} sm={12} xs={12}>
            <FeaturedFrobotSection
              featuredFrobots={featuredFrobots}
              imageBaseUrl={s3_base_url}
            />
          </Grid>
        </Grid>
      </Box>
    </>
  )
}
