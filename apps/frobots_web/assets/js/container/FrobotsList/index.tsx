import React from 'react'
import { Box, Grid, Typography, Card } from '@mui/material'

interface FrobotInterface {
  id: number
  name: string
  avatar: string
  blockly_code: string
  brain_code: string
  class: string
  xp: number
}

export default (props: any) => {
  const { frobotList, currentUser } = props

  return (
    <Box>
      <Box mt={4}>
        <Grid container alignItems="left" justifyContent="left" spacing={5}>
          {frobotList.map((frobot: FrobotInterface) => (
            <Grid item md={3} key={frobot.id}>
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
                      />
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

          {currentUser.sparks && (
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
                        + Create Frobot
                      </Typography>
                    </Box>
                  </a>
                  <Box textAlign={'center'} my={2}>
                    <Typography fontWeight={'bold'} variant="subtitle1">
                      Use spark to create frobot
                    </Typography>
                    <Typography
                      display={'block'}
                      lineHeight={1}
                      variant="caption"
                    >
                      {currentUser.sparks} Sparks Left
                    </Typography>
                  </Box>
                </Box>
              </Card>
            </Grid>
          )}
        </Grid>
      </Box>
    </Box>
  )
}
