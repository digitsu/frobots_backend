import React from 'react'
import { Box, Grid, Typography, Card } from '@mui/material'
const frobotsList = [
  {
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot1.png',
    name: 'X-Tron',
    xp: 5000000,
  },
  {
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot2.png',
    name: 'New Horizon',
    xp: 1223500,
  },
  {
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot3.png',
    name: 'Bumble bee',
    xp: 5231100,
  },
  {
    bgUrl: '/images/frobot_bg.png',
    src: '/images/frobot4.png',
    name: 'Megatron',
    xp: 5312100,
  },
]
export default () => (
  <Grid container alignItems="center" justifyContent="center" spacing={5}>
    {frobotsList.map((featuredFrobot) => (
      <Grid item md={3}>
        <Card
          sx={{
            backgroundColor: '#212B36',
            color: '#fff',
            borderRadius: 4,
          }}
        >
          <Box>
            <Box position={'relative'}>
              <Box
                component={'img'}
                src={featuredFrobot.bgUrl}
                width="100%"
                height="100%"
              ></Box>
              <Box
                sx={{
                  position: 'absolute',
                  top: '50%',
                  left: '50%',
                  p: 5,
                  transform: 'translate(-50%, -50%)',
                }}
                component={'img'}
                width={'100%'}
                src={featuredFrobot.src}
              ></Box>
            </Box>
            <Box textAlign={'center'} my={2}>
              <Typography fontWeight={'bold'} variant="subtitle1">
                {featuredFrobot.name}
              </Typography>
              <Typography display={'block'} lineHeight={1} variant="caption">
                {featuredFrobot.xp} XP
              </Typography>
            </Box>
          </Box>
        </Card>
      </Grid>
    ))}
    {new Array(8 - frobotsList.length).fill('').map(() => (
      <Grid item md={3}>
        <Card
          sx={{
            backgroundColor: '#212B36',
            color: '#fff',
            borderRadius: 4,
          }}
        >
          <Box>
            <Box position={'relative'}>
              <Box
                width="100%"
                height="100%"
                sx={{ filter: 'grayscale(1)' }}
                component={'img'}
                src={'/images/createfrobot_bg.png'}
              ></Box>
              <Typography
                variant="h6"
                display={'flex'}
                justifyContent={'center'}
                width={'100%'}
                position={'absolute'}
                top={'50%'}
              >
                +Create Frobot
              </Typography>
            </Box>
            <Box textAlign={'center'} my={2}>
              <Typography fontWeight={'bold'} variant="subtitle1">
                Empty Spark
              </Typography>
              <Typography display={'block'} lineHeight={1} variant="caption">
                Click to forge a new frobot
              </Typography>
            </Box>
          </Box>
        </Card>
      </Grid>
    ))}
  </Grid>
)