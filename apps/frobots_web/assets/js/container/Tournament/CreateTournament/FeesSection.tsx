import React from 'react'
import { Grid, Box, TextField, Typography, Button, Card } from '@mui/material'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'

export default () => {
  const dispatch = useDispatch()
  const { setCommisionFee, setArenaFee, setPlatformFee, setEntryFee } =
    createTournamentActions
  const { commission_percent, arena_fees_percent, platform_fees, entry_fees } =
    useSelector((store: any) => store.createTournament)
  const prizeLabel = {
    0: 'First',
    1: 'Second',
    2: 'Third',
  }
  return (
    <Grid container spacing={2}>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Commision Percent`}
            fullWidth
            onChange={(evt) => dispatch(setCommisionFee(evt.target.value))}
            value={commission_percent}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Arena Fees Percent`}
            fullWidth
            onChange={(evt) => dispatch(setArenaFee(evt.target.value))}
            value={arena_fees_percent}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Platform Fee`}
            fullWidth
            onChange={(evt) => dispatch(setPlatformFee(evt.target.value))}
            value={platform_fees}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Entry Fee`}
            fullWidth
            onChange={(evt) => dispatch(setEntryFee(evt.target.value))}
            value={entry_fees}
          />
        </Box>
      </Grid>
    </Grid>
  )
}
