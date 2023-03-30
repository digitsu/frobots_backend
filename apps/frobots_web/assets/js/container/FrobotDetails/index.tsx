import React from 'react'
import { Box, Typography } from '@mui/material'
import AttachedEquipments from './AttachedEquipments'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid from './SlideBarGrid'

const currentUser = {
  id: 3,
  email: 'demo_user@test.com',
  admin: null,
  active: null,
  name: null,
  confirmed_at: null,
  migrated_user: false,
  inserted_at: '2023-03-22 12:30:00',
  updated_at: '2023-03-22 12:30:00',
}

const frobotDetails = {
  id: 9,
  name: 'X-Tron',
  bio: 'XTron is a revolutionary new robot that combines the latest in artificial intelligence and robotics technology to bring you an interactive and intelligent companion. This innovative device is designed to bring a new level of fun and excitement to your life. With its sleek, modern design and intuitive controls, the Frobot is easy to use and operate.',
  class: 'Target',
  brain_code: '',
  blockly_code: '',
  xp: 91568,
  avatar: '/images/frobot1.png',
  user_id: 3,
  mech: 'Mech MK2',
  isBoost: true,
  ranking: '12345',
  mechXframeHealth: '60',
  isRepair: true,
  speed: '20km/hr',
  hp: '120',
  wins: '132/200',
  qdosEarned: '$235790',
  battlelogs: [
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
  ],
  xframe_inst: [],
  cannon_inst: [
    {
      id: 1,
      avatar: '/images/frobot_bg.png',
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
      avatar: '/images/frobot_bg.png',
      name: 'Cannon MK III',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
  ],
  scanner_inst: [
    {
      id: 1,
      avatar: '/images/frobot_bg.png',
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
      avatar: '/images/frobot_bg.png',
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
  ],
  missile_inst: [],
  inserted_at: '2023-03-22 10:25:17',
  updated_at: '2023-03-22 10:25:17',
}

const getFrobotDetails = () => {
  const frobotId = location.search.split('?id=')[1]
  let result: any

  switch (frobotId) {
    case '1':
      result = {
        ...frobotDetails,
        id: 1,
        user_id: 1,
        avatar: '/images/frobot1.png',
      }
      break

    case '2':
      result = {
        ...frobotDetails,
        id: 2,
        user_id: 2,
        avatar: '/images/frobot2.png',
        name: 'New Horizon',
        bio: 'New Horizon is a versatile robot designed to explore and analyze new frontiers. Equipped with advanced sensors and communication systems, this machine is capable of gathering and transmitting vast amounts of data from even the most remote and challenging environments. Its modular design allows for easy customization to suit any mission, and its advanced AI enables it to adapt and learn on the fly. With New Horizon, the possibilities for discovery are endless.',
      }
      break

    case '3':
      result = {
        ...frobotDetails,
        id: 3,
        user_id: 3,
        avatar: '/images/frobot3.png',
        name:"Titan",
        bio:'Titan is a formidable fighting robot built for combat with incredible strength and durability. Standing at 10 feet tall, this menacing machine is equipped with advanced weaponry and impenetrable armor, making it nearly invincible in battle. Its programming allows it to quickly analyze and strategize against opponents, making Titan a feared competitor in the arena.'
      }
      break

    default:
      result = {
        ...frobotDetails,
      }
      break
  }

  return result
}

export default (props:any) => {
  const frobotDetails = getFrobotDetails()
  const isOwnedFrobot =
    frobotDetails.user_id === currentUser.id || location.search.split('?id=')[1] ==='1'
  const pl = isOwnedFrobot?0:4;
  
  return (
    <>
      <Box display={'flex'} sx={{pl:pl}}>
        <SlideBarGrid isOwnedFrobot={isOwnedFrobot} />

        <Box width={'100%'} m={'auto'} pr={3}>
          <Typography
            sx={{
              pb: 2,
              pt: 2,
            }}
            variant="h5"
          >
            {frobotDetails.name}
          </Typography>
          <FrobotDetailsContainer
            frobotDetails={frobotDetails}
            currentUser={currentUser}
            isOwnedFrobot={isOwnedFrobot}
          />
          <AttachedEquipments
            equipments={[
              ...frobotDetails.cannon_inst,
              ...frobotDetails.scanner_inst,
              ...frobotDetails.missile_inst,
            ]}
            isOwnedFrobot={isOwnedFrobot}
          />
          <BattlesTable battleLogs={frobotDetails.battlelogs} />
        </Box>
      </Box>
    </>
  )
}
