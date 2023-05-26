import React from 'react'
import {
  Grid,
  Card,
  Box,
  Typography,
  Button,
  Table,
  TableBody,
  TableCell,
  TableRow,
} from '@mui/material'

interface AdvancedDetailsProps {
  frobotDetails: any
  isOwnedFrobot: boolean
  xFrameDetails: any
}

export default (props: AdvancedDetailsProps) => {
  const { frobotDetails, isOwnedFrobot, xFrameDetails } = props

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
        <Box position={'unset'} height={'100%'}>
          <Box height={'100%'}>
            <Typography
              variant="h5"
              display={'flex'}
              justifyContent={'left'}
              width={'100%'}
              position={'absolute'}
              top={'10%'}
              left={'10%'}
            >
              {frobotDetails.xp || 0} XP
            </Typography>

            <Box
              sx={{
                position: 'absolute',
                left: '50%',
                top: '50%',
                px: 4,
                transform: 'translate(-50%, -50%)',
                width: '100%',
              }}
            >
              <Table>
                <TableBody sx={{ color: '#fff' }}>
                  <TableRow>
                    <TableCell align="left">Ranking</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {frobotDetails.ranking || 0}
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell align="left">Health</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {xFrameDetails?.health || 0} /{' '}
                      {xFrameDetails?.max_health || 0} ap
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell align="left">Accel Speed</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {xFrameDetails?.accel_speed_mss || 0} m/s^2
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell align="left">Max Speed</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {xFrameDetails?.max_speed_ms || 0} m/s
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell align="left">Turn Speed</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {xFrameDetails?.turn_speed || 0}%
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell align="left">Max Throttle</TableCell>
                    <TableCell align="center">:</TableCell>
                    <TableCell align="right">
                      {xFrameDetails?.max_throttle || 0}
                    </TableCell>
                  </TableRow>
                </TableBody>
              </Table>
            </Box>
          </Box>
          <Box
            sx={{
              position: 'absolute',
              left: '50%',
              px: 4,
              transform: 'translate(-50%, -50%)',
              width: '100%',
              bottom: 10,
            }}
          >
            {isOwnedFrobot && (
              <Button
                variant={'outlined'}
                fullWidth
                onClick={handleOpenBrainCode}
              >
                View Brain Code
              </Button>
            )}
          </Box>
        </Box>
      </Card>
    </Grid>
  )
}
