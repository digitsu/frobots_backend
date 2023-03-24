import React from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Box, Typography, Autocomplete, TextField, Button } from '@mui/material'
import { createMatchActions } from '../../redux/slices/createMatch'

export default (props: any) => {
  const { templates } = props
  const templateFrobots =
    templates?.map(({ name, brain_code, blockly_code }, index) => ({
      label: name,
      brain_code,
      blockly_code,
      id: index,
    })) || []
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
        <TextField
          fullWidth
          label="Select Countdown Timer"
          placeholder="01:00:00"
          value={countDownTimer}
          onChange={(evt) => dispatch(setCountdownTimer(evt.target.value))}
        />
      </Box>
      <Box mt={6}>
        <Button
          variant="contained"
          fullWidth
          sx={{ py: 1.5, mb: 10 }}
          onClick={() => dispatch(incrementStep())}
        >
          Next
        </Button>
      </Box>
    </Box>
  )
}
