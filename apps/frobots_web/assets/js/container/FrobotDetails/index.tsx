import React from 'react'
import { Box } from '@mui/material'
import AttachedEquipments from './AttachedEquipments'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid, { UserFrobot } from './SlideBarGrid'

const battlelogs = [
  {
    matchId: '7f54cf1e315d',
    name: 'Battle 7',
    winner: 'TBD',
    xp: 'TBD',
    status: 'live',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3153',
    name: 'Battle 7',
    winner: 'TBD',
    xp: 'TBD',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e315e',
    name: 'Battle 3',
    winner: 'Kakashi Hatake',
    xp: '+50',
    status: 'lost',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3146',
    name: 'Battle 7',
    winner: 'Kaztro',
    xp: '+5000',
    status: 'won',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '7f54cf1e3156',
    name: 'Battle 9',
    winner: 'Satoru Gojo',
    xp: '+5000',
    status: 'won',
    time: '21th March 2023 20:00:00',
  },
  {
    matchId: '7f54cf1e325j',
    name: 'Battle 2',
    winner: 'Kaztro',
    xp: '+20000',
    status: 'won',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: '3f54cf1e315e',
    name: 'Battle 12',
    winner: 'TBD',
    xp: 'TBD',
    status: 'upcoming',
    time: '20th Feb 2022 20:00:00',
  },
  {
    matchId: 'Lf54cf1e315d',
    name: 'Battle 7',
    winner: 'Kaztro',
    xp: '+0',
    status: 'lost',
    time: '20th Feb 2022 20:00:00',
  },
]

const xframe_inst = []
const cannon_inst = [
  {
    id: 1,
    avatar: '/images/equipment_canon_mk_2.png',
    name: 'Cannon MK II',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 2,
    avatar: '/images/equipment_canon_mk_3.png',
    name: 'Cannon MK III',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
]
const scanner_inst = [
  {
    id: 1,
    avatar: '/images/equipment_scanner_mk_1.png',
    name: 'Scanner MK I',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 2,
    avatar: '/images/equipment_scanner_mk_2.png',
    name: 'Scanner MK II',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
  {
    id: 3,
    avatar: '/images/frobot_bg.png',
    name: 'Scanner MK III',
    props: {
      maxRange: '700m',
      magazine: 2,
      damage: '[40,3], [20,5], [5,10]',
      reload: 16,
      roF: 16,
    },
  },
]
const missile_inst = []

interface FrobotDetailsProps {
  frobotDetails: any
  currentUser: any
  userFrobots: UserFrobot[]
}

export default (props: FrobotDetailsProps) => {
  const { frobotDetails, currentUser, userFrobots } = props
  const isOwnedFrobot = frobotDetails.user_id === currentUser.id

  return (
    <Box mt={5}>
      <>
        <Box display={'flex'} sx={{ pl: isOwnedFrobot ? 0 : 4 }}>
          {isOwnedFrobot && (
            <SlideBarGrid
              userFrobots={userFrobots}
              currentFrobot={frobotDetails}
              currentUser={currentUser}
            />
          )}

          <Box
            width={'100%'}
            m={'auto'}
            pr={6}
            sx={{
              borderLeft: isOwnedFrobot ? '2px solid #2C333C' : 'none',
              paddingLeft: isOwnedFrobot ? 1.5 : 0,
            }}
          >
            <FrobotDetailsContainer
              frobotDetails={frobotDetails}
              currentUser={currentUser}
              isOwnedFrobot={isOwnedFrobot}
            />
            {/* <AttachedEquipments
              equipments={[...cannon_inst, ...scanner_inst, ...missile_inst]}
              isOwnedFrobot={isOwnedFrobot}
            /> */}
            {/* <BattlesTable battleLogs={battlelogs} /> */}
          </Box>
        </Box>
      </>
    </Box>
  )
}
