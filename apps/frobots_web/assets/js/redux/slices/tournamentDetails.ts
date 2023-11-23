import { createSlice } from '@reduxjs/toolkit'

const initialState = {
  currentFrobot: null,
  tournamentPlayers: [],
}

const tournamentDetails = createSlice({
  name: 'tournamentDetails',
  initialState,
  reducers: {
    setCurrentFrobot: (state, action) => {
      state.currentFrobot = action.payload
    },
    setTournamentPlayers: (state, action) => {
      state.tournamentPlayers = action.payload
    },
  },
})

export const tournamentDetailsReducer = tournamentDetails.reducer,
  tournamentDetailsActions = tournamentDetails.actions
