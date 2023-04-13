import React from 'react'
import { Grid, Card, Box, Typography, Button } from '@mui/material'

interface AdvancedDetailsProps {
  frobotDetails: any
  isOwnedFrobot: boolean
}

export default (props: AdvancedDetailsProps) => {
  const { frobotDetails, isOwnedFrobot } = props

  const handleOpenBrainCode = () => {
    window.location.href = `/garage/frobot/braincode?id=${frobotDetails.frobot_id}`
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
            paddingTop: '100%',
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
            {frobotDetails.xp || 0} XP
          </Typography>
        </Box>
        <Box
          sx={{
            position: 'absolute',
            top: '10%',
            bottom: 0,
            left: 0,
            right: 0,
          }}
        >
          <Box>
            <Grid pl={4} container spacing={2}>
              <Grid item>
                <Box textAlign="left" alignItems={'baseline'}>
                  <Typography my={2.2} variant="subtitle2">
                    Ranking
                  </Typography>
                  <Box display={'flex'}>
                    <Typography variant="subtitle2">Health</Typography>
                    {frobotDetails.isRepair && (
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
                    Turn Speed
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    Throttle
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
                </Box>
              </Grid>
              <Grid pr={3} item xs={7}>
                <Box textAlign="right">
                  <Typography my={2.2} variant="subtitle2">
                    {frobotDetails.ranking || 0}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {frobotDetails?.xframe_inst?.health || 0} /{' '}
                    {frobotDetails?.xframe_inst?.max_health || 0}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {frobotDetails?.xframe_inst?.max_speed_ms || 0}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {frobotDetails?.xframe_inst?.turn_speed || 0}
                  </Typography>
                  <Typography my={2.2} variant="subtitle2">
                    {frobotDetails?.xframe_inst?.max_throttle || 0}
                  </Typography>
                </Box>
              </Grid>
            </Grid>
          </Box>
        </Box>
        <Box
          sx={{
            position: 'absolute',
            top: '80%',
            bottom: 0,
            left: 0,
            right: 0,
          }}
        >
          {isOwnedFrobot && (
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
          )}
        </Box>
      </Card>
    </Grid>
  )
}
