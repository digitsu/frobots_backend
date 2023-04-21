import React from 'react'
import { Box, Grid, Typography, Card } from '@mui/material'

interface RankingDetails {
  attempts: number
  avatar: string
  frobots_count: number
  matches_participated: number
  matches_won: number
  points: number
  rank: number
  username: string
  xp: number
}

interface ProfileDetailsProps {
  user_name: string
  user_avatar: string
  ranking_details?: RankingDetails
}

export default (props: ProfileDetailsProps) => {
  const { user_name, user_avatar, ranking_details } = props

  const handleOpenUserProfile = () => {
    window.location.href = `/profile`
  }

  return (
    <Card>
      <Box p={3} height={240}>
        <Grid container spacing={1} height={'100%'} alignItems={'center'}>
          <Grid item xs={9} sm={9} md={9} lg={9}>
            <Box mt={2}>
              {' '}
              <Typography variant="h6">{user_name}</Typography>
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
                    # {ranking_details?.rank || 0}
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
                    {ranking_details?.matches_won || 0} /{' '}
                    {ranking_details?.matches_participated || 0}
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
                    {ranking_details?.xp || 0} XP
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
                    {ranking_details?.points || 0} Q
                  </Typography>
                </Box>
              </Box>
            </Box>
          </Grid>
          <Grid item xs={3} sm={3} md={3} lg={3}>
            <Box
              margin={'auto'}
              src={user_avatar || '/images/user_logo.png'}
              component={'img'}
              onClick={handleOpenUserProfile}
            />
          </Grid>
        </Grid>
      </Box>
    </Card>
  )
}
