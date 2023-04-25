import { combineReducers } from '@reduxjs/toolkit'
import { createFrobotReducer } from './slices/createFrobot'
import { createMatchReducer } from './slices/createMatch'
import { arenaLobbyReducer } from './slices/arenaLobbySlice'
export default combineReducers({
  createFrobot: createFrobotReducer,
  createMatch: createMatchReducer,
  arenaLobby: arenaLobbyReducer,
})
