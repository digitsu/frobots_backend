import React, { FC } from 'react'
import PropTypes from 'prop-types'
import { Box, Card, Grid, Typography } from '@mui/material'
import ViewMore from '../../components/generic/Button/ViewMore'

interface MatchInterface {
  matchId: string
  matchName: string
  src: string
  role: string
}

interface MatchContainerProps {
  matches: MatchInterface[]
}

export const MatchContainer: FC<MatchContainerProps> = (props) => {
  const { matches, ...other } = props

  return (
    <Grid
      container
      alignItems="flex-start"
      justifyContent="flex-start"
      spacing={5}
      {...other}
    >
      {matches.map((featuredMatch: MatchInterface) => (
        <Grid item lg={2} md={2} sm={6} xs={12} key={featuredMatch.matchId}>
          <Card
            sx={{
              backgroundColor: '#212B36',
              color: '#fff',
              borderRadius: 4,
            }}
          >
            <Box width={'100%'} m={'auto'}>
              <Box
                borderRadius={4}
                component={'img'}
                width={'100%'}
                src={featuredMatch.src}
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
                      {featuredMatch.matchName}
                    </Typography>
                  </Box>
                  <Box textAlign={'right'}>
                    {' '}
                    <ViewMore label={''} />
                  </Box>
                </Box>
              </Box>
            </Box>
          </Card>
        </Grid>
      ))}
    </Grid>
  )
}

MatchContainer.propTypes = {
  matches: PropTypes.any,
}
