import React, { useState } from 'react'
import { Card, CardContent, Typography, Box, Button } from '@mui/material'
import { makeStyles } from '@mui/styles'
import { SeverityPill } from '../../components/generic/SeverityPill'
import moment from 'moment'
import JoinTournamentPopup from './JoinTournamentPopup'

const useStyles = makeStyles((theme) => ({
  card: {
    background: 'linear-gradient(135deg, rgb(15 141 77), rgb(22 28 36))',
    color: 'white',
    padding: theme.spacing(4),
    textAlign: 'center',
    position: 'relative',
  },
  title: {
    fontSize: '2.5rem',
    fontWeight: 'bold',
    marginBottom: theme.spacing(2),
  },
  description: {
    fontSize: '1.2rem',
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
    background: 'linear-gradient(135deg, rgb(15 141 77), rgb(22 28 36))',
    zIndex: -1,
  },
}))

function TournamentBanner({
  tournament_details,
  joinTournament,
  user_frobots,
  s3_base_url,
}) {
  const classes = useStyles()
  const scheduleDate = moment.unix(tournament_details.starts_at)
  const day = scheduleDate.format('D')
  const month = scheduleDate.format('MMMM')
  const year = scheduleDate.format('y')
  const time = scheduleDate.format('hh:mm A')
  const [showJoinTournamentPrompt, setShowJoinTournamentPrompt] =
    useState(false)
  const joinTournamentPopupHandler = () => {
    setShowJoinTournamentPrompt(true)
  }

  return (
    <Card className={classes.card}>
      <div className={classes.overlay}></div>{' '}
      {/* Transparent Gradient Overlay */}
      <CardContent sx={{ textAlign: 'left' }}>
        <Box display={'flex'} alignItems={'center'} gap={2}>
          <Typography className={classes.title} variant="h3">
            {tournament_details.name}
          </Typography>
          <SeverityPill color="success">
            {tournament_details.status}
          </SeverityPill>
        </Box>
        <Box display={'flex'} alignItems={'center'} gap={1}>
          <Typography variant="h1">{day}</Typography>
          <Box>
            <Typography variant="h6" textTransform={'uppercase'}>
              {month}
            </Typography>
            <Box display={'flex'} alignItems={'center'} gap={1}>
              <Typography variant="h6">{year}</Typography>
              <Typography variant="body2">{time}</Typography>
            </Box>
          </Box>
        </Box>
        <Typography className={classes.description} variant="body1">
          Registration Fee: <b>{tournament_details.entry_fees} QDOS</b> per
          frobot
        </Typography>
        <Typography className={classes.description} variant="body1">
          Minimum Participants: <b>{tournament_details.min_participants} Frobots</b>
        </Typography>
        <Box
          display={'flex'}
          alignItems={'end'}
          gap={2}
          justifyContent={'space-between'}
        >
          <Box>
            <Typography className={classes.description} variant="body1">
              Prizes:
              {tournament_details.prizes.map((prize, index) => (
                <>
                  <b>
                    {index === 0 ? ' 🥇' : index === 1 ? ' 🥈' : ' 🥉'} {prize}{' '}
                    QDOS{' '}
                  </b>
                  {index !== tournament_details.prizes.length - 1 && '| '}
                </>
              ))}
            </Typography>
            <Typography className={classes.description} variant="body1">
              Book your spot now and be part of eSports history!
            </Typography>
          </Box>
          <Box>
            <Button
              onClick={joinTournamentPopupHandler}
              sx={{ px: 5, py: 1 }}
              variant="contained"
            >
              Join
            </Button>
          </Box>
        </Box>
      </CardContent>
      <JoinTournamentPopup
        user_frobots={user_frobots}
        s3_base_url={s3_base_url}
        open={showJoinTournamentPrompt}
        tournament_details={tournament_details}
        joinTournament={joinTournament}
        cancelAction={() => setShowJoinTournamentPrompt(false)}
      />
    </Card>
  )
}

export default TournamentBanner
