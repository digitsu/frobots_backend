import React, { FC } from 'react'
import PropTypes from 'prop-types'
import { Box, Grid, Typography, Card } from '@mui/material'

export interface FrobotInterface {
  id: number
  name: string
  avatar: string
  blockly_code: string
  brain_code: string
  class: string
  xp: number
}

export interface FrobotListContainerProps {
  frobotList: FrobotInterface[]
}

export const FrobotListContainer: FC<FrobotListContainerProps> = (props) => {
  const { frobotList } = props

  return (
    <Grid container alignItems="center" justifyContent="center" spacing={5}>
      {frobotList.map((frobot: FrobotInterface) => (
        <Grid item md={3}>
          <Card
            sx={{
              backgroundColor: '#212B36',
              color: '#fff',
              borderRadius: 4,
            }}
          >
            <Box>
              <a href={`/garage/frobot?id=${frobot.id}`}>
                <Box position={'relative'}>
                  <Box
                    component={'img'}
                    src={'/images/frobot_bg.png'}
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
                    src={frobot.avatar}
                  ></Box>
                </Box>
                <Box textAlign={'center'} my={2}>
                  <Typography fontWeight={'bold'} variant="subtitle1">
                    {frobot.name}
                  </Typography>
                  <Typography
                    display={'block'}
                    lineHeight={1}
                    variant="caption"
                  >
                    {frobot.xp} XP
                  </Typography>
                </Box>
              </a>
            </Box>
          </Card>
        </Grid>
      ))}
      {new Array(8 - frobotList.length).fill('').map(() => (
        <Grid item md={3}>
          <Card
            sx={{
              backgroundColor: '#212B36',
              color: '#fff',
              borderRadius: 4,
            }}
          >
            <Box>
              <a href={'/garage/create'}>
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
              </a>
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
}

FrobotListContainer.propTypes = {
  frobotList: PropTypes.any,
}
