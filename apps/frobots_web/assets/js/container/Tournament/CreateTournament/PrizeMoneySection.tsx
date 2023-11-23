import { Box, Grid, TextField } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'

function PrizeForm({ formik }) {
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
              onChange={(evt) => {
                dispatch(setPrizes({ data: evt.target.value, index }))
                formik.values[`prize${index}`] = evt.target.value
              }}
              value={prize}
              name={`prize${index}`}
              error={Boolean(
                formik.touched[`prize${index}`] &&
                  formik.errors[`prize${index}`]
              )}
              helperText={
                formik.touched[`prize${index}`] &&
                formik.errors[`prize${index}`]
              }
            />
          </Box>
        </Grid>
      ))}
    </Grid>
  )
}

export default PrizeForm
