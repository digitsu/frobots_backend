import { createSlice } from '@reduxjs/toolkit'
import moment from 'moment'

const initialState = {
  activeStep: 0,
  name: '',
  description: '',
  starts_at: moment().add(1, 'day').format('YYYY-MM-DDTHH:mm'),
  mapSelected: null,
  min_participants: 8,
  prizes: [0, 0, 0],
  commission_percent: 0,
  arena_fees_percent: 0,
  bonus_percent: 0,
  entry_fees: 0,
}

const createTournamentSlice = createSlice({
  name: 'createTournament',
  initialState,
  reducers: {
    incrementStep: (state) => {
      state.activeStep += 1
    },
    decrementStep: (state) => {
      state.activeStep -= 1
    },
    changeTournamentStartTime: (state, action) => {
      state.starts_at = action.payload
    },
    setTournamentName: (state, action) => {
      state.name = action.payload
    },
    setDescription: (state, action) => {
      state.description = action.payload
    },
    setMap: (state, action) => {
      state.mapSelected = action.payload
    },
    setParticipants: (state, action) => {
      state.min_participants = action.payload
    },
    setPrizes: (state, action) => {
      state.prizes[action.payload.index] = action.payload.data
    },
    setCommisionFee: (state, action) => {
      state.commission_percent = action.payload
    },
    setArenaFee: (state, action) => {
      state.arena_fees_percent = action.payload
    },
    setBonusFee: (state, action) => {
      state.bonus_percent = action.payload
    },
    setEntryFee: (state, action) => {
      state.entry_fees = action.payload
      //state.bonus_percent = action.payload * state.min_participants
    },
  },
})

export const createTournamentReducer = createTournamentSlice.reducer,
  createTournamentActions = createTournamentSlice.actions
