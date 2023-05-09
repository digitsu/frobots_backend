import { createSlice } from '@reduxjs/toolkit'

const initialState = {
  equipment: {},
  activeEquipmentKey: '',
}

const equipmentSlice = createSlice({
  name: 'frobotEquipment',
  initialState,
  reducers: {
    setCurrentEquipment: (state, action) => {
      state.equipment = action.payload
    },
    setActiveEquipmentKey: (state, action) => {
      state.activeEquipmentKey = action.payload
    },
  },
})

export const frobotEquipmentReducer = equipmentSlice.reducer,
  frobotEquipmentActions = equipmentSlice.actions
