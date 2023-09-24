import { Box, Button, Card, Divider, Grid, Typography } from '@mui/material'
import React from 'react'
import { SeverityPill } from '../../components/generic/SeverityPill'
import { tournamentMatches } from '../../mock/tournament'
const s3BaseUrl = 'https://ap-south-1.linodeobjects.com/frobots-assets/'
const statuses = {
  pending: 'warning',
  running: 'secondary',
  done: 'primary',
  cancelled: 'error',
  aborted: 'error',
}
export default ({ tournament_details }) => {
  return (
    <Grid container spacing={2} sx={{ pb: 4 }}>
      {tournamentMatches.map((tournamentMatch) => (
        <Grid item xs={12} sm={3}>
          <Card sx={{ p: 2 }}>
            <Typography variant="subtitle1" textAlign={'center'} sx={{ mb: 2 }}>
              {tournamentMatch.title}
            </Typography>
            <Box
              display={'flex'}
              alignItems={'center'}
              justifyContent={'space-around'}
            >
              {tournamentMatch.slots.map((slot, index) => (
                <>
                  <Box
                    display={'flex'}
                    flexDirection={'column'}
                    alignItems={'center'}
                    gap={1}
                  >
                    <Box
                      component={'img'}
                      src={`${s3BaseUrl}${slot.frobot.avatar}`}
                      width={70}
                      height={70}
                      sx={{
                        filter:
                          slot.status.toLowerCase() === 'lost' &&
                          'grayscale(1)',
                      }}
                    />
                    <Typography variant="body2">{slot.frobot.name}</Typography>
                    {tournamentMatch.status?.toLowerCase() === 'done' ? (
                      <Typography
                        variant="body2"
                        color={
                          slot.status.toLowerCase() === 'won'
                            ? '#00AB55'
                            : '#FF4842'
                        }
                      >
                        {slot.status.toUpperCase()}
                      </Typography>
                    ) : (
                      <Typography variant="body2" color={'text.disabled'}>
                        TBD
                      </Typography>
                    )}
                  </Box>
                  {index !== tournamentMatch.slots.length - 1 && (
                    <Typography variant="h6">Vs</Typography>
                  )}
                </>
              ))}
            </Box>
            <Divider sx={{ my: 2 }} />
            <Box display={'flex'} alignItems={'center'} gap={1} mb={1}>
              <Typography variant="subtitle2" color={'text.secondary'}>
                {tournamentMatch.match_time}
              </Typography>
              <Box
                component={'div'}
                width={4}
                height={4}
                borderRadius={'50%'}
                sx={{ backgroundColor: 'text.disabled' }}
              />
              <Typography variant="caption" color={'text.secondary'}>
                Starting at 6 PM
              </Typography>
            </Box>
            <Box
              display={'flex'}
              justifyContent={'space-between'}
              alignItems={'center'}
              sx={{ py: 1 }}
            >
              <SeverityPill
                color={statuses[tournamentMatch.status]}
                sx={{ px: 2, py: 0.5 }}
              >
                <Typography variant="caption" textTransform={'capitalize'}>
                  {tournamentMatch.status}
                </Typography>
              </SeverityPill>
              {(tournamentMatch.status?.toLowerCase() === 'done' ||
                tournamentMatch.status?.toLowerCase() === 'running') && (
                <Box>
                  <Button
                    variant={
                      tournamentMatch.status?.toLowerCase() === 'done'
                        ? 'outlined'
                        : 'contained'
                    }
                  >
                    {' '}
                    <Typography variant="caption">
                      {tournamentMatch.status?.toLowerCase() === 'done'
                        ? 'Replay'
                        : 'Watch'}
                    </Typography>
                  </Button>
                </Box>
              )}
            </Box>
          </Card>
        </Grid>
      ))}
    </Grid>
  )
}
