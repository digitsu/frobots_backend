import { Box, Button, Card, Divider, Grid, Typography } from '@mui/material'
import React from 'react'
import { SeverityPill } from '../../components/generic/SeverityPill'
import { tournamentMatches } from '../../mock/tournament'
import moment from 'moment'
const statuses = {
  pending: 'warning',
  running: 'secondary',
  done: 'primary',
  cancelled: 'error',
  aborted: 'error',
}
export default ({ tournament_details, s3_base_url }) => {
  return (
    <Grid container spacing={2} sx={{ pb: 4 }}>
      {tournament_details.matches?.map((tournamentMatch) => {
        const tournamentStatus = tournamentMatch.status?.toLowerCase()
        return (
          <Grid item xs={12} sm={6} md={4} lg={3}>
            <Card sx={{ p: 2 }}>
              <Typography
                variant="subtitle2"
                textAlign={'center'}
                sx={{ mb: 2 }}
              >
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
                        src={`${s3_base_url}${slot.frobot.avatar}`}
                        width={70}
                        height={70}
                        sx={{
                          filter:
                            slot.status.toLowerCase() === 'lost' &&
                            'grayscale(1)',
                        }}
                      />
                      <Typography variant="body2">
                        {slot.frobot.name}
                      </Typography>
                      {tournamentStatus === 'done' &&
                      tournamentMatch.battlelog !== null ? (
                        <Typography
                          variant="body2"
                          color={
                            tournamentMatch.battlelog.winners.includes(
                              slot.frobot_id
                            )
                              ? '#00AB55'
                              : '#FF4842'
                          }
                        >
                          {tournamentMatch.battlelog.winners.includes(
                            slot.frobot_id
                          )
                            ? 'WON'
                            : 'LOST'}
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
                  {moment(tournamentMatch.match_time).format('DD MMM YYYY')}
                </Typography>
                <Box
                  component={'div'}
                  width={4}
                  height={4}
                  borderRadius={'50%'}
                  sx={{ backgroundColor: 'text.disabled' }}
                />
                <Typography variant="caption" color={'text.secondary'}>
                  Starting at{' '}
                  {moment(tournamentMatch.match_time).format('hh:mm A')}
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
                {(tournamentStatus === 'done' ||
                  tournamentStatus === 'running') && (
                  <Box>
                    <Button
                      href={`/arena/${tournamentMatch.id}/${
                        tournamentStatus === 'done' ? 'replay' : 'simulation'
                      }`}
                      target={'_blank'}
                      variant={
                        tournamentStatus === 'done' ? 'outlined' : 'contained'
                      }
                    >
                      {' '}
                      <Typography variant="caption">
                        {tournamentStatus === 'done' ? 'Replay' : 'Watch'}
                      </Typography>
                    </Button>
                  </Box>
                )}
              </Box>
            </Card>
          </Grid>
        )
      })}
    </Grid>
  )
}
