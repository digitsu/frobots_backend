import React from 'react'
import { Grid, Box, TextField, Typography, Button, Card } from '@mui/material'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'

function PrizeForm() {
  const dispatch = useDispatch()
  const { setPrizes } = createTournamentActions
  const { prizes } = useSelector((store: any) => store.createTournament)
  const prizeLabel = {
    0: 'First',
    1: 'Second',
    2: 'Third',
  }
  return (
    <Grid container spacing={2}>
      {prizes.map((prize, index) => (
        <Grid item md={4}>
          <Box my={2}>
            <TextField
              type={'number'}
              label={`${prizeLabel[index]} Prize`}
              fullWidth
              onChange={(evt) =>
                dispatch(setPrizes({ data: evt.target.value, index }))
              }
              value={prize}
            />
          </Box>
        </Grid>
      ))}
    </Grid>
  )
}

export default PrizeForm
