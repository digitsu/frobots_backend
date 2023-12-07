import React from 'react'
import { Grid, Box, TextField, Typography, Button, Card } from '@mui/material'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'

export default ({ formik }) => {
  const dispatch = useDispatch()
  const { setCommisionFee, setArenaFee, setBonusFee, setEntryFee } =
    createTournamentActions
  const { commission_percent, arena_fees_percent, bonus_percent, entry_fees } =
    useSelector((store: any) => store.createTournament)

  return (
    <Grid container spacing={2}>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Entry Fee`}
            fullWidth
            onChange={(evt) => {
              dispatch(setEntryFee(evt.target.value))
              formik.handleChange(evt)
            }}
            value={entry_fees}
            error={Boolean(
              formik.touched.entry_fees && formik.errors.entry_fees
            )}
            helperText={formik.touched.entry_fees && formik.errors.entry_fees}
            name={'entry_fees'}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Bonus %`}
            fullWidth
            onChange={(evt) => {
              dispatch(setBonusFee(evt.target.value))
              formik.handleChange(evt)
            }}
            value={bonus_percent}
            error={Boolean(
              formik.touched.bonus_percent && formik.errors.bonus_percent
            )}
            helperText={
              formik.touched.bonus_percent && formik.errors.bonus_percent
            }
            name={'bonus_percent'}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Commission %`}
            fullWidth
            onChange={(evt) => {
              dispatch(setCommisionFee(evt.target.value))
              formik.handleChange(evt)
            }}
            value={commission_percent}
            error={Boolean(
              formik.touched.commission_percent &&
                formik.errors.commission_percent
            )}
            helperText={
              formik.touched.commission_percent &&
              formik.errors.commission_percent
            }
            name={'commission_percent'}
          />
        </Box>
      </Grid>
      <Grid item md={3}>
        <Box my={2}>
          <TextField
            type={'number'}
            label={`Arena Fees %`}
            fullWidth
            onChange={(evt) => {
              dispatch(setArenaFee(evt.target.value))
              formik.handleChange(evt)
            }}
            value={arena_fees_percent}
            error={Boolean(
              formik.touched.arena_fees_percent &&
                formik.errors.arena_fees_percent
            )}
            helperText={
              formik.touched.arena_fees_percent &&
              formik.errors.arena_fees_percent
            }
            name={'arena_fees_percent'}
          />
        </Box>
      </Grid>


    </Grid>
  )
}
