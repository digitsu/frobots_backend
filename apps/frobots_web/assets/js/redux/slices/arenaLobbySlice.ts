import { createSlice } from '@reduxjs/toolkit'
import moment from 'moment'

const initialState = {
  activeStep: 0,
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
    name: `#Frobot ${index + 1}`,
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
  userFrobots: [],
  protobots: [],
  currentActiveSlot: null,
  s3Url: '',
}

const ArenaLobbySlice = createSlice({
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
    setProtobots: (state, action) => {
      state.protobots = action.payload
    },
    setUserFrobots: (state, action) => {
      state.userFrobots = action.payload
    },
    setSlots: (state, action) => {
      state.slots = action.payload
    },
    setS3BaseUrl: (state, action) => {
      state.s3Url = action.payload
    },
  },
})

export const arenaLobbyReducer = ArenaLobbySlice.reducer,
  arenaLobbyActions = ArenaLobbySlice.actions
