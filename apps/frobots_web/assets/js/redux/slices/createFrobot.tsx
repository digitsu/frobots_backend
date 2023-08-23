import { createSlice } from '@reduxjs/toolkit'
import { createFrobotOnboardingSteps } from '../../mock/OnboardingSteps'

const initialState = {
  activeStep: 0,
  starterMech: {},
  frobotName: '',
  bio: '',
  brainCode: {},
  blocklyCode: '',
  selectedProtobot: null,
  introSteps: createFrobotOnboardingSteps,
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
    setBlocklyCode: (state, action) => {
      state.blocklyCode = action.payload
    },
    onExit: (state, action) => {
      state.stepsEnabled = false
    },
    setSelectedProtobot: (state, action) => {
      state.selectedProtobot = action.payload
    },
  },
})

export const createFrobotReducer = createFrobotSlice.reducer,
  createFrobotActions = createFrobotSlice.actions
