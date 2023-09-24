import { createSlice } from '@reduxjs/toolkit'
import moment from 'moment'

const initialState = {
  currentFrobot: null,
}

const tournamentDetails = createSlice({
  name: 'tournamentDetails',
  initialState,
  reducers: {
    setCurrentFrobot: (state, action) => {
      state.currentFrobot = action.payload
    },
  },
})

export const tournamentDetailsReducer = tournamentDetails.reducer,
  tournamentDetailsActions = tournamentDetails.actions
