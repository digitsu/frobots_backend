import { createSlice } from '@reduxjs/toolkit'
import moment from 'moment'

const initialState = {
  activeStep: 2,
  matchTitle: '',
  matchDescription: '',
  matchTime: moment(new Date()).format('YYYY-MM-DDTHH:mm'),
  countDownTimer: 0,
  mapSelected: {},
  minFrobots: 1,
  maxFrobots: 1,
  slotPositions: 6,
  slots: new Array(6).fill('').map((_val, index) => ({
    id: index,
    type: 'open',
    url: '/images/frobot.svg',
    label: `#Frobot ${index + 1}`,
    slotDetails: null,
  })),
  slotOptions: [
    {
      slotId: 1,
      type: 'open',
      label: 'Open',
      content:
        'Select this option to keep the frobot slot  empty and  open to other players in the game world for joining. By default all slots will be open.',
      url: '/images/frobot.svg',
    },
    {
      slotId: 2,
      type: 'host',
      label: 'Host Frobot',
      content:
        'Select this option if you want enlist your frobot for the match in this slot as the host frobot',
      url: '/images/red_frobot.svg',
    },
    {
      slotId: 3,
      type: 'proto',
      label: 'Protobot',
      content:
        'Select this option to reserve this slot to enlist protobot NPC’s in this match',
      url: '/images/yellow_frobot.svg',
    },
    {
      slotId: 4,
      type: 'closed',
      label: 'Closed',
      content:
        'Select this option to keep the frobot slot  closed  or reserved from other players from joining. This can be modified before starting the match',
      url: '/images/grey_frobot.svg',
    },
  ],
  userFrobots: [
    {
      id: 1,
      label: 'My Frobot',
      brain_code: '',
      avatar: 'https://via.placeholder.com/50.png',
      xp: 3440,
      blockly_code: '',
      bio: 'Armor points: 80, Turn Speed: 65%, Max Speed: 40m/s,  Acceleration: 7m/s2',
      type: 'host',
    },
    {
      id: 2,
      label: 'My Frobot 2',
      brain_code: '',
      avatar: 'https://via.placeholder.com/50.png',
      xp: 312,
      blockly_code: '',
      bio: 'Armor points: 80, Turn Speed: 65%, Max Speed: 40m/s,  Acceleration: 7m/s2',
      type: 'host',
    },
  ],
  protobots: [
    {
      id: 1,
      label: 'Protobot',
      brain_code: '',
      avatar: 'https://via.placeholder.com/50.png',
      xp: 3440,
      blockly_code: '',
      bio: 'Armor points: 80, Turn Speed: 65%, Max Speed: 40m/s,  Acceleration: 7m/s2',
      type: 'host',
    },
    {
      id: 2,
      label: 'Protobot 2',
      brain_code: '',
      avatar: 'https://via.placeholder.com/50.png',
      xp: 312,
      blockly_code: '',
      bio: 'Armor points: 80, Turn Speed: 65%, Max Speed: 40m/s,  Acceleration: 7m/s2',
      type: 'host',
    },
  ],
  currentActiveSlot: null,
}

const createMatchSlice = createSlice({
  name: 'createFrobot',
  initialState,
  reducers: {
    incrementStep: (state) => {
      state.activeStep += 1
    },
    decrementStep: (state) => {
      state.activeStep -= 1
    },
    changeMatchTime: (state, action) => {
      state.matchTime = action.payload
    },
    setMatchTitle: (state, action) => {
      state.matchTitle = action.payload
    },
    setDescription: (state, action) => {
      state.matchDescription = action.payload
    },
    setCountdownTimer: (state, action) => {
      state.countDownTimer = action.payload
    },
    setMap: (state, action) => {
      state.mapSelected = action.payload
    },
    setMinFrobots: (state, action) => {
      state.minFrobots = action.payload
    },
    setMaxFrobots: (state, action) => {
      state.maxFrobots = action.payload
    },
    setCurrentActiveSlot: (state, action) => {
      state.currentActiveSlot = action.payload
    },
    updateSlot: (state, action) => {
      state.slots = state.slots.map((slot) =>
        slot.id === action.payload.id ? action.payload : slot
      )
    },
  },
})

export const createMatchReducer = createMatchSlice.reducer,
  createMatchActions = createMatchSlice.actions
