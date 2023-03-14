import { createSlice } from '@reduxjs/toolkit'

const initialState = {
  activeStep: 0,
  starterMech: {},
  frobotName: '',
  bio: '',
  brainCode: {},
}

const createFrobotSlice = createSlice({
  name: 'createFrobot',
  initialState,
  reducers: {
    incrementStep: (state) => {
      state.activeStep += 1
    },
    decrementStep: (state) => {
      state.activeStep -= 1
    },
    changeStarterMech: (state, action) => {
      state.starterMech = action.payload
    },
    setFrobotName: (state, action) => {
      state.frobotName = action.payload
    },
    setBio: (state, action) => {
      state.bio = action.payload
    },
    setBrainCode: (state, action) => {
      state.brainCode = action.payload
    },
  },
})

export const createFrobotReducer = createFrobotSlice.reducer,
  createFrobotActions = createFrobotSlice.actions
