import { Box } from '@mui/material'
import React from 'react'
import AttachedEquipments from './AttachedEquipments'
import BattlesTable from './BattlesTable'
import FrobotAdvancedDetails from './FrobotAdvancedDetails'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid from './SlideBarGrid'

export default () => (
  <>
    <Box width={'100%'} m={'auto'}>
      <FrobotDetailsContainer />
      <AttachedEquipments />
      <BattlesTable />
    </Box>
    {/* <Box sx={{ position: 'relative', height: '100%' }}>
      <Box sx={{ position: 'sticky', top: 150, left: 4, zIndex: 2 }}>
        <SlideBarGrid />
      </Box>
    </Box> */}
  </>
)
