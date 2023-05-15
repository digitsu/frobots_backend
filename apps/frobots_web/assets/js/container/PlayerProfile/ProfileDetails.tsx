import React from 'react'
import { Box, Grid, Typography, Card } from '@mui/material'

interface RankingDetails {
  attempts: number
  avatar: string
  frobot_count: number
  matches_participated: number
  matches_won: number
  points: number
  rank: number
  username: string
  xp: number
}

interface ProfileDetailsProps {
  user_name: string
  ranking_details: RankingDetails
  user_avatar: string
  frobotsCount: number
}

export default (props: ProfileDetailsProps) => {
  const { frobotsCount, user_name, ranking_details, user_avatar } = props

  const getRanking = (rank: number) => {
    return rank === 0 ? 'Not Ranked' : `# ${rank}`
  }

  return (
    <Card>
      <Box py={2} px={3}>
        <Grid container spacing={1} height={'100%'} alignItems={'center'}>
          <Grid item xs={12} sm={12} md={9} lg={9} pt={0}>
            <Box>
              <Typography variant="h6">{user_name}</Typography>
              <Box display={'flex'} flexDirection={'column'} gap={1} mt={2}>
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
                    {getRanking(ranking_details?.rank || 0)}
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
                <Box
                  display={'flex'}
                  alignItems={'center'}
                  justifyContent={'space-between'}
                >
                  <Typography flex={2} variant="caption">
                    Frobots
                  </Typography>
                  <Typography flex={1} variant="caption">
                    :
                  </Typography>
                  <Typography flex={2} variant="caption">
                    {frobotsCount || 0}
                  </Typography>
                </Box>
              </Box>
            </Box>
          </Grid>
          <Grid item xs={12} sm={12} md={3} lg={3}>
            <Box
              height={240}
              margin={'auto'}
              src={user_avatar}
              component={'img'}
            />
          </Grid>
        </Grid>
      </Box>
    </Card>
  )
}
