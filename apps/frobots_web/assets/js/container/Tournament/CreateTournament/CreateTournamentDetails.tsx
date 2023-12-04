import { Box, Button, TextField, Typography } from '@mui/material'
import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { createTournamentActions } from '../../../redux/slices/createTournament'
import FeesSection from './FeesSection'
import PrizeMoneySection from './PrizeMoneySection'
import { useFormik } from 'formik'
import * as Yup from 'yup'

export default ({ tournament_initial_name }) => {
  const dispatch = useDispatch()
  const {
    incrementStep,
    setTournamentName,
    setDescription,
    changeTournamentStartTime,
    setParticipants,
  } = createTournamentActions
  const {
    name,
    description,
    starts_at,
    participants,
    prizes,
    commission_percent,
    arena_fees_percent,
    platform_fees,
    entry_fees,
  } = useSelector((store: any) => store.createTournament)
  const formik = useFormik({
    initialValues: {
      name: tournament_initial_name,
      description,
      participants,
      ...Object.fromEntries(
        Array.from({ length: 3 }, (_, i) => [`prize${i}`, prizes[i]])
      ),
      commission_percent,
      arena_fees_percent,
      platform_fees,
      entry_fees,
    },
    validationSchema: Yup.object({
      name: Yup.string().required('Tournament Name is required'),
      description: Yup.string().required('Description is required'),
      participants: Yup.number()
        .required()
        .min(8, 'Minimum 8 partipants are required to start the tournament')
        .max(
          256,
          'Maximum 256 partipants are only allowed to participate in the tournament'
        ),
      ...Object.fromEntries(
        Array.from({ length: 3 }, (_, i) => [
          `prize${i}`,
          Yup.number()
            .positive('Prize amount should be greater than zero')
            .required('Please enter the prize money'),
        ])
      ),
      commission_percent: Yup.number()
        .positive('Please enter a valid percentage.')
        .test('add-to-hundred', 'All the percentages should add to 100', () => {
          const sum =
            Number(commission_percent) +
            Number(arena_fees_percent)
          return sum === 100
        }),
      arena_fees_percent: Yup.number().positive(
        'Please enter a valid percentage.'
      ),
      platform_fees: Yup.number().positive('Please enter a valid percentage.'),
      entry_fees: Yup.number().positive('Please enter a valid percentage.'),
    }),

    onSubmit: async (): Promise<void> => {
      try {
        dispatch(incrementStep())
      } catch (err) {
        console.error(err)
      }
    },
  })
  return (
    <form noValidate onSubmit={formik.handleSubmit}>
      <Box width={'60%'} m={'auto'} mt={10}>
        <Typography mb={2} variant={'body1'} fontWeight={'bold'}>
          Enter Match Details
        </Typography>
        <Box my={2}>
          <TextField
            onChange={(evt) => {
              dispatch(setTournamentName(evt.target.value))
              formik.handleChange(evt)
            }}
            error={Boolean(formik.touched.name && formik.errors.name)}
            label={'Tournament Name'}
            fullWidth
            value={name}
            name={'name'}
            helperText={formik.touched.name && formik.errors.name}
          />
        </Box>
        <Box my={2}>
          <TextField
            label={'Description'}
            fullWidth
            onChange={(evt) => {
              dispatch(setDescription(evt.target.value))
              formik.handleChange(evt)
            }}
            error={Boolean(
              formik.touched.description && formik.errors.description
            )}
            inputProps={{ style: { height: 100 } }}
            multiline
            InputProps={{
              style: { resize: 'none' },
            }}
            value={description}
            name={'description'}
            helperText={formik.touched.description && formik.errors.description}
          />
        </Box>
        <Box my={2}>
          <TextField
            type={'number'}
            label={'Partcipants count'}
            fullWidth
            onChange={(evt) => {
              dispatch(setParticipants(evt.target.value))
              formik.handleChange(evt)
            }}
            error={Boolean(
              formik.touched.participants && formik.errors.participants
            )}
            name={'participants'}
            value={participants}
            helperText={
              formik.touched.participants && formik.errors.participants
            }
          />
        </Box>
        <PrizeMoneySection formik={formik} />
        <FeesSection formik={formik} />
        <Box my={2}>
          <TextField
            type={'datetime-local'}
            label={'Tournament Start'}
            fullWidth
            onChange={(evt) =>
              dispatch(changeTournamentStartTime(evt.target.value))
            }
            value={starts_at}
          />
        </Box>
        <Box mt={6}>
          <Button
            type="submit"
            variant="contained"
            fullWidth
            sx={{ py: 1.5, mb: 10 }}
          >
            Next
          </Button>
        </Box>
      </Box>
    </form>
  )
}
