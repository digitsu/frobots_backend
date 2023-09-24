import { Box, Button, TextField, Typography } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'
import FeesSection from './FeesSection'
import PrizeMoneySection from './PrizeMoneySection'
export default () => {
  const dispatch = useDispatch()
  const {
    incrementStep,
    setTournamentName,
    setDescription,
    changeTournamentStartTime,
    setParticipants,
  } = createTournamentActions
  const { name, description, starts_at, participants } = useSelector(
    (store: any) => store.createTournament
  )
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Typography mb={2} variant={'body1'} fontWeight={'bold'}>
        Enter Match Details
      </Typography>
      <Box my={2}>
        <TextField
          onChange={(evt) => dispatch(setTournamentName(evt.target.value))}
          label={'Tournament Name'}
          fullWidth
          value={name}
        />
      </Box>
      <Box my={2}>
        <TextField
          label={'Description'}
          fullWidth
          onChange={(evt) => dispatch(setDescription(evt.target.value))}
          inputProps={{ style: { height: 100 } }}
          multiline
          InputProps={{
            style: { resize: 'none' },
          }}
          value={description}
        />
      </Box>
      <Box my={2}>
        <TextField
          type={'number'}
          label={'Partcipants count'}
          fullWidth
          onChange={(evt) => dispatch(setParticipants(evt.target.value))}
          value={participants}
        />
      </Box>
      <PrizeMoneySection />
      <FeesSection />
      <Box my={2}>
        <TextField
          type={'datetime-local'}
          label={'Select Match Time'}
          fullWidth
          onChange={(evt) =>
            dispatch(changeTournamentStartTime(evt.target.value))
          }
          value={starts_at}
        />
      </Box>
      <Box mt={6}>
        <Button
          variant="contained"
          fullWidth
          disabled={participants <= 0 || name === ''}
          sx={{ py: 1.5, mb: 10 }}
          onClick={() => dispatch(incrementStep())}
        >
          Next
        </Button>
      </Box>
    </Box>
  )
}
