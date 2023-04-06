import React from 'react'
import { Box, Grid, Typography } from '@mui/material'
import SlideBarGrid from '../FrobotDetails/SlideBarGrid'
import EquipmentBayDetails from './EquipmentBayDetails'
import AttachedEquipments from './AttachedEquipments'
import AvailableEquipments from './AvailableEquipments'

const equipmentDetails = {
  id: 1,
  avatar: '/images/equipment_canon_mk_2_large.png',
  name: 'Cannon MK II',
  props: {
    maxRange: '700m',
    magazine: 2,
    damage: '[40,3], [20,5], [5,10]',
    reload: 16,
    roF: 16,
  },
}

const equipments = {
  availableEquipments: [
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
    {
      id: 3,
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
      id: 4,
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
      id: 4,
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
    {
      id: 5,
      avatar: '/images/frobot_bg.png',
      name: 'Cannon MK I',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
    {
      id: 6,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK IV',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
    {
      id: 7,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
  ],
  attachedEquipments: [
    {
      id: 4,
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
    {
      id: 3,
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
      id: 4,
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
      id: 7,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
    ,
    {
      id: 10,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },

    {
      id: 15,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },

    {
      id: 15,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },

    {
      id: 15,
      avatar: '/images/frobot_bg.png',
      name: 'Scanner MK V',
      props: {
        maxRange: '700m',
        magazine: 2,
        damage: '[40,3], [20,5], [5,10]',
        reload: 16,
        roF: 16,
      },
    },
  ],
}

export default (props: any) => {
  const isOwnedFrobot = true
  return (
    <Box display={'flex'} width={'100%'} sx={{ pb:2}}>
      <SlideBarGrid isOwnedFrobot={isOwnedFrobot} />

      <Box
        width={'100%'}
        height={'100%'}
        m={'auto'}
      
        sx={{
          paddingRight: 0,
          borderLeft: isOwnedFrobot ? '2px solid #2C333C' : 'none',
          paddingLeft: isOwnedFrobot ? 1.5 : 0,
        }}
      >
        <Typography
          sx={{
            pb: 2,
            pt: 2,
          }}
          variant="h4"
        >
          {'Titan'}
        </Typography>
        <Grid container lg={12}>
          <EquipmentBayDetails equipmentDetails={equipmentDetails} />
          <Box width={20}></Box>
          <AvailableEquipments props={equipments.availableEquipments} />
        </Grid>

        <AttachedEquipments
          equipments={equipments.attachedEquipments}
          isOwnedFrobot={true}
        ></AttachedEquipments>
      </Box>
    </Box>
  )
}
