import { Box, Card, Typography, Grid, Button } from '@mui/material'
import React from 'react'
import { useSelector } from 'react-redux'
import MilitaryTechIcon from '@mui/icons-material/MilitaryTech'
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth'
import GroupIcon from '@mui/icons-material/Group'
import moment from 'moment'

export default ({ s3_base_url, createTournament }) => {
  const {
    mapSelected,
    name,
    description,
    participants,
    prizes,
    commission_percent,
    arena_fees_percent,
    bonus_percent,
    entry_fees,
    starts_at,
  } = useSelector((store: any) => store.createTournament)
  const scheduleDate = moment(starts_at)
  const day = scheduleDate.format('D')
  const month = scheduleDate.format('MMMM')
  const year = scheduleDate.format('y')
  const time = scheduleDate.format('hh:mm A')

  const handleTournamentCreate = () => {
    createTournament({
      name,
      starts_at: moment(starts_at).valueOf() / 1000,
      description,
      prizes,
      arena_id: mapSelected?.id || 1,
      commission_percent,
      arena_fees_percent,
      bonus_percent,
      entry_fees,
      participants,
      status: 'open',
    })
  }
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Card sx={{ p: 3 }}>
        <Box display={'flex'} alignItems={'start'} gap={2} mb={2}>
          <Box
            component={'img'}
            src={`${s3_base_url}${mapSelected?.image_url}`}
            width={150}
            height={150}
          />
          <Box width={'100%'}>
            <Box mb={2}>
              <Box mb={2}>
                <Typography variant="h4">{name}</Typography>
              </Box>
              {description && (
                <Box maxHeight={82} sx={{ overflowY: 'scroll' }}>
                  <Typography variant="body2">{description}</Typography>
                </Box>
              )}
            </Box>
          </Box>
        </Box>
        <Box display={'flex'} alignItems={'center'} gap={1} mb={2}>
          <CalendarMonthIcon fontSize={'large'} />
          <Typography variant="h2">{day}</Typography>
          <Box>
            <Typography variant="body1" textTransform={'uppercase'}>
              {month}
            </Typography>
            <Typography variant="caption" fontWeight={'bold'} sx={{ mr: 1 }}>
              {year}
            </Typography>
            <Typography variant="caption">{time}</Typography>
          </Box>
        </Box>
        <Box display={'flex'} gap={1} alignItems={'center'} mb={2} ml={0.5}>
          <GroupIcon fontSize="medium" />
          <Typography variant="body1">{participants} Participants</Typography>
        </Box>
        <Grid container mb={2}>
          <Grid item md={3}>
            <Box display={'flex'}>
              <MilitaryTechIcon fontSize={'large'} sx={{ color: 'gold' }} />
              <Box>
                <Typography
                  fontSize={12}
                  variant="subtitle2"
                  textTransform={'uppercase'}
                >
                  First Prize
                </Typography>
                <Typography>300</Typography>
              </Box>
            </Box>
          </Grid>
          <Grid item md={3}>
            <Box display={'flex'} gap={1}>
              <MilitaryTechIcon fontSize={'large'} sx={{ color: 'silver' }} />
              <Box>
                <Typography
                  fontSize={12}
                  variant="subtitle2"
                  textTransform={'uppercase'}
                >
                  Second Prize
                </Typography>
                <Typography>200</Typography>
              </Box>
            </Box>
          </Grid>
          <Grid item md={3}>
            <Box display={'flex'} gap={1}>
              <MilitaryTechIcon
                fontSize={'large'}
                sx={{ color: 'saddlebrown' }}
              />
              <Box>
                <Typography
                  fontSize={12}
                  variant="subtitle2"
                  textTransform={'uppercase'}
                >
                  Third Prize
                </Typography>
                <Typography>100</Typography>
              </Box>
            </Box>
          </Grid>
        </Grid>
        <Grid container ml={1.5}>
          <Grid item md={3}>
            <Box>
              <Typography fontSize={12} variant="body2">
                Commision Percent
              </Typography>
              <Typography>{commission_percent}</Typography>
            </Box>
          </Grid>
          <Grid item md={3}>
            <Box>
              <Typography fontSize={12} variant="body2">
                Arena Fees Percent
              </Typography>
              <Typography>{arena_fees_percent}</Typography>
            </Box>
          </Grid>
          <Grid item md={3}>
            <Box>
              <Typography fontSize={12} variant="body2">
                Platform Fees
              </Typography>
              <Typography>{bonus_percent}</Typography>
            </Box>
          </Grid>
          <Grid item md={3}>
            <Box>
              <Typography fontSize={12} variant="body2">
                Entry Fees
              </Typography>
              <Typography>{entry_fees}</Typography>
            </Box>
          </Grid>
        </Grid>
      </Card>
      <Box display={'flex'} justifyContent={'flex-end'} mt={6} width={'100%'}>
        <Button
          fullWidth
          onClick={handleTournamentCreate}
          variant="contained"
          sx={{ px: 5, py: 1.5 }}
        >
          Create
        </Button>
      </Box>
    </Box>
  )
}
