import { combineReducers } from '@reduxjs/toolkit'
import { countReducers } from './slices/counter'

export default combineReducers({
  count: countReducers,
})
