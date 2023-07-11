import React from 'react'
import { Box, Grid, Typography, Card, Container } from '@mui/material'

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
  const { frobotList, currentUser, s3_base_url } = props

  return (
    <Box>
      <Box mt={4} m={'auto'}>
        <Container sx={{ maxWidth: 1440 }}>
          <Grid container alignItems="left" justifyContent="left" spacing={5}>
            {frobotList.map((frobot: FrobotInterface) => (
              <Grid item xl={3} lg={3} md={4} sm={6} xs={12} key={frobot.id}>
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
                            transform: 'translate(-50%, -50%)',
                            objectFit: 'cover',
                            borderRadius: '20px 20px 10px 10px',
                          }}
                          component={'img'}
                          width={'100%'}
                          height={'100%'}
                          src={`${s3_base_url}${frobot.avatar}`}
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
              <Grid item xl={3} lg={3} md={3} sm={6} xs={12}>
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
                          borderRadius="20px 20px 10px 10px"
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
        </Container>
      </Box>
    </Box>
  )
}
