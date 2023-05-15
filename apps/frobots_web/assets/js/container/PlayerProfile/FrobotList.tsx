import React from 'react'
import { Box, Card, Grid, Typography } from '@mui/material'

type Frobot = {
  id: number
  name: string
  avatar: string
  xp: number
}

interface FrobotListProps {
  s3BaseUrl: string
  userFrobots: Frobot[]
}

export default ({ s3BaseUrl, userFrobots }: FrobotListProps) => {
  const OpenFrobotDetails = (frobotId: number) => {
    window.open(`/garage/frobot?id=${frobotId}`, '_blank')
  }

  return (
    <Card>
      <Box py={2} px={3}>
        <Grid container spacing={3}>
          {userFrobots.map((frobot: Frobot) => (
            <Grid
              item
              xl={3}
              lg={3}
              md={4}
              sm={6}
              xs={12}
              key={frobot.id}
              onClick={() => OpenFrobotDetails(frobot.id)}
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
                    src={`${s3BaseUrl}${frobot.avatar}`}
                  />
                </Box>
                <Box textAlign={'center'} mt={3}>
                  <Typography variant="body2">{frobot.name}</Typography>
                </Box>
              </Box>
            </Grid>
          ))}
        </Grid>
      </Box>
    </Card>
  )
}
