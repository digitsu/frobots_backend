import { Grid, Box, Card, Typography } from '@mui/material'
import React from 'react'
import ViewMore from '../../components/generic/Button/ViewMore'
const championShipInfo = [
  {
    src: '/images/championship-mock-1.png',
    label: 'Asian Champions Announced',
  },
  {
    src: '/images/championship-mock-2.png',
    label: 'Best performing Brain Codes this month',
  },
  {
    src: '/images/championship-mock-3.png',
    label: 'Europe Championship date Announced',
  },
  {
    src: '/images/championship-mock-4.png',
    label: 'Earn 2x XP with this match',
  },
]
export default () => {
  return (
    <Box my={4}>
      <Grid container spacing={3}>
        {championShipInfo.map((featuredFrobot) => (
          <Grid item lg={3} md={4} sm={6} xs={12}>
            <Box position={'relative'}>
              <Box width={'100%'} m={'auto'}>
                <Box
                  borderRadius={4}
                  component={'img'}
                  width={'100%'}
                  src={featuredFrobot.src}
                />
                <Box
                  position={'absolute'}
                  bottom={0}
                  width={'100%'}
                  p={1}
                  sx={{
                    borderRadius: 4,
                    overflow: 'hidden',
                    '::after': {
                      content: '""',
                      position: 'absolute',
                      top: 0,
                      left: 0,
                      width: '100%',
                      height: '100%',
                      zIndex: 0,
                      backgroundImage:
                        'linear-gradient(180deg, rgba(0, 0, 0, 0) -1.23%, #000000 80%);',
                    },
                  }}
                >
                  <Box
                    position={'relative'}
                    zIndex={1}
                    display={'flex'}
                    height={100}
                    justifyContent={'space-between'}
                    flexDirection={'column'}
                  >
                    <Box>
                      {' '}
                      <Typography variant="h6" fontWeight={'bold'}>
                        {featuredFrobot.label}
                      </Typography>
                    </Box>
                    <Box textAlign={'right'}>
                      {' '}
                      <ViewMore label={'Learn More'} />
                    </Box>
                  </Box>
                </Box>
              </Box>
            </Box>
          </Grid>
        ))}
      </Grid>
    </Box>
  )
}
