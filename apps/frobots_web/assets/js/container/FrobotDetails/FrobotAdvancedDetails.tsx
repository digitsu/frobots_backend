import { Grid, Card, Box, Typography, Button } from '@mui/material'
import React from 'react'

const advanceDetails = {
  id: 1,
  ranking: '12345',
  mechXFrameHealth: '60',
  isRepair: true,
  speed: '20km/hr',
  hp: '120',
  wins: '132/200',
  qdosEarned: '$235790',
}

export default () => {
  const handleOpenBrainCode = () => {
    window.location.href = `/garage/frobot/braincode?id=${advanceDetails.id}`
  }

  return (
    <Grid item lg={4} md={6} sm={6} xs={12}>
      <Card
        sx={{
          bgcolor: '#212B36',
          borderRadius: 4,
          paddingTop: '100%',
          overflowY: 'scroll',
          '&::-webkit-scrollbar': { display: 'none' },
          position: 'relative',
          '@media (max-width: 600px)': {
            paddingTop: '50%',
          },
        }}
      >
        <Box
          sx={{
            position: 'absolute',
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
          }}
        >
          <Typography sx={{ pl: 4, pt: 2, mt: 1, mb: 2 }} variant={'h5'}>
            2780451 XP
          </Typography>
          <Box>
            <Grid pl={4} container spacing={2}>
              <Grid item>
                <Box textAlign="left" alignItems={'baseline'}>
                  <Typography my={2.2} variant="subtitle2">
                    Ranking
                  </Typography>
                  <Box display={'flex'}>
                    <Typography variant="subtitle2">Health</Typography>
                    {advanceDetails.isRepair && (
                      <Button
                        color="warning"
                        size="small"
                        style={{ fontSize: '10px' }}
                      >
                        Repair
                      </Button>
                    )}
                  </Box>
                  <Typography my={2.2} variant="subtitle2">
                    Speed
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    HP
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    Wins
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    QDOS Earned
                  </Typography>
                </Box>
              </Grid>
              <Grid item>
                <Box textAlign="center">
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    :
                  </Typography>
                </Box>
              </Grid>
              <Grid pr={3} item xs={7}>
                <Box textAlign="right">
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.ranking}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.mechXFrameHealth}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.speed}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.hp}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.wins}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {advanceDetails.qdosEarned}
                  </Typography>
                </Box>
              </Grid>
            </Grid>
            <Box
              sx={{
                mx: 4,
              }}
            >
              <Button
                variant="outlined"
                fullWidth
                onClick={handleOpenBrainCode}
              >
                View Brain Code
              </Button>
            </Box>
          </Box>
        </Box>
      </Card>
    </Grid>
  )
}
