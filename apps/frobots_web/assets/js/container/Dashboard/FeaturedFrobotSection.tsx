import { Grid, Box, Typography } from '@mui/material'
import React from 'react'
const featuredFrobots = [
  {
    id: 1,
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot1.png',
    name: 'X Tron',
    xp: 5000000,
  },
  {
    id: 2,
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot2.png',
    name: 'New Horizon',
    xp: 1223500,
  },
  {
    id: 3,
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot3.png',
    name: 'Bumble bee',
    xp: 5231100,
  },
  {
    id: 8,
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot4.png',
    name: 'Megatron',
    xp: 5312100,
  },
]
export default () => {
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
      }}
    >
      <Box width={'90%'} m={'auto'}>
        <Typography sx={{ pl: 0, mt: 1, mb: 2 }} variant={'body1'}>
          Featured Frobots
        </Typography>
        <Grid container spacing={3}>
          {featuredFrobots.map((featuredFrobot) => (
            <Grid
              item
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
                    src={featuredFrobot.bgUrl}
                  ></Box>
                  <Box
                    sx={{ transform: 'translate(-50%, -50%)' }}
                    top={'50%'}
                    left={'50%'}
                    zIndex={1}
                    position={'absolute'}
                    component={'img'}
                    src={featuredFrobot.src}
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
