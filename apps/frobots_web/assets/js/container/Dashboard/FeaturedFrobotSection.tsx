import React from 'react'
import { Grid, Box, Typography } from '@mui/material'

type FeaturedFrobot = {
  id: number
  name: string
  avatar: string
  xp: number
}

type FeaturedFrobotsProps = {
  featuredFrobots: FeaturedFrobot[]
  imageBaseUrl: string
}

export default (props: FeaturedFrobotsProps) => {
  const { featuredFrobots, imageBaseUrl } = props

  const handleOpenDetails = (frobotId: number) => {
    window.location.href = `/garage/frobot?id=${frobotId}`
  }

  return (
    <Box
      sx={{
        width: '100%',
        p: 3,
        backgroundColor: '#212B36',
        color: '#fff',
        borderRadius: 4,
      }}
    >
      <Box width={'90%'} m={'auto'}>
        <Typography sx={{ pl: 0, mt: 1, mb: 2 }} variant={'body1'}>
          Featured Frobots
        </Typography>
        <Grid container spacing={3}>
          {featuredFrobots.map((featuredFrobot: FeaturedFrobot) => (
            <Grid
              item
              xl={3}
              lg={3}
              md={4}
              sm={6}
              xs={12}
              key={featuredFrobot.id}
              onClick={() => handleOpenDetails(featuredFrobot.id)}
            >
              <Box>
                <Box position={'relative'} width={'100%'} m={'auto'}>
                  <Box
                    component={'img'}
                    width={'100%'}
                    src={'/images/frobot_bg.png'}
                  ></Box>
                  <Box
                    sx={{
                      transform: 'translate(-50%, -50%)',
                      objectFit: 'cover',
                      borderRadius: '20px 20px 10px 10px',
                    }}
                    top={'50%'}
                    left={'50%'}
                    zIndex={1}
                    position={'absolute'}
                    component={'img'}
                    src={`${imageBaseUrl}${featuredFrobot.avatar}`}
                  />
                </Box>
                <Box textAlign={'center'} mt={3}>
                  <Typography fontWeight={'bold'} variant="subtitle1">
                    {featuredFrobot.name}
                  </Typography>
                  <Typography
                    display={'block'}
                    lineHeight={1}
                    variant="caption"
                  >
                    {featuredFrobot.xp} XP
                  </Typography>
                </Box>
              </Box>
            </Grid>
          ))}
        </Grid>
      </Box>
    </Box>
  )
}
