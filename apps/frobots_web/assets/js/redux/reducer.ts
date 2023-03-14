import { combineReducers } from '@reduxjs/toolkit'
import { createFrobotReducer } from './slices/createFrobot'
export default combineReducers({
  createFrobot: createFrobotReducer,
})
