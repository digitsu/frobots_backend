import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Box, Typography, TextField, Button, Autocomplete } from '@mui/material'
import { createMatchActions } from '../../redux/slices/createMatch'

export default (props: any) => {
  const { templates } = props
  const dispatch = useDispatch()
  const {
    incrementStep,
    setMatchTitle,
    setDescription,
    changeMatchTime,
    setCountdownTimer,
  } = createMatchActions

  const { matchTitle, matchDescription, matchTime, countDownTimer } =
    useSelector((store: any) => store.createMatch)
  const timerOptions = [1, 2, 3, 5, 10].map((count, index) => ({
    id: index,
    label: count,
  }))
  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Typography mb={2} variant={'body1'} fontWeight={'bold'}>
        Enter Match Details
      </Typography>
      <Box my={2}>
        <TextField
          onChange={(evt) => dispatch(setMatchTitle(evt.target.value))}
          label={'Match Title'}
          fullWidth
          value={matchTitle}
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
          value={matchDescription}
        />
      </Box>
      <Box my={2}>
        <TextField
          type={'datetime-local'}
          label={'Select Match Time'}
          fullWidth
          onChange={(evt) => dispatch(changeMatchTime(evt.target.value))}
          value={matchTime}
        />
      </Box>
      <Box my={2}>
        <Autocomplete
          id="match-duration"
          key="brain-code"
          options={timerOptions}
          disableClearable
          onChange={(_item, target) => {
            dispatch(setCountdownTimer(target.label * 60))
          }}
          renderInput={(params) => (
            <TextField
              {...params}
              label="Select Match Duration"
              name="match-duration-input"
            />
          )}
        />
      </Box>
      <Box mt={6}>
        <Button
          variant="contained"
          fullWidth
          disabled={countDownTimer === 0}
          sx={{ py: 1.5, mb: 10 }}
          onClick={() => dispatch(incrementStep())}
        >
          Next
        </Button>
      </Box>
    </Box>
  )
}
