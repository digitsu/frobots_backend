import { combineReducers } from '@reduxjs/toolkit'
import { createFrobotReducer } from './slices/createFrobot'
import { createMatchReducer } from './slices/createMatch'
import { arenaLobbyReducer } from './slices/arenaLobbySlice'
import { frobotEquipmentReducer } from './slices/frobotEquipment'
import { matchSimulationReducer } from './slices/matchSimulationSlice'

export default combineReducers({
  createFrobot: createFrobotReducer,
  createMatch: createMatchReducer,
  arenaLobby: arenaLobbyReducer,
  frobotEquipment: frobotEquipmentReducer,
  matchSimulation: matchSimulationReducer,
})
