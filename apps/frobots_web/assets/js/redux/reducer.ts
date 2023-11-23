import { combineReducers } from '@reduxjs/toolkit'
import { createFrobotReducer } from './slices/createFrobot'
import { createMatchReducer } from './slices/createMatch'
import { arenaLobbyReducer } from './slices/arenaLobbySlice'
import { frobotEquipmentReducer } from './slices/frobotEquipment'
import { matchSimulationReducer } from './slices/matchSimulationSlice'
import { createTournamentReducer } from './slices/createTournament'
import { tournamentDetailsReducer } from './slices/tournamentDetails'

export default combineReducers({
  createFrobot: createFrobotReducer,
  createMatch: createMatchReducer,
  arenaLobby: arenaLobbyReducer,
  frobotEquipment: frobotEquipmentReducer,
  matchSimulation: matchSimulationReducer,
  createTournament: createTournamentReducer,
  tournamentDetails: tournamentDetailsReducer,
})
