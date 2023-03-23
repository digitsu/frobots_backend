import { combineReducers } from '@reduxjs/toolkit'
import { createFrobotReducer } from './slices/createFrobot'
import { createMatchReducer } from './slices/createMatch'

export default combineReducers({
  createFrobot: createFrobotReducer,
  createMatch: createMatchReducer,
})
