import { Box } from '@mui/material'
import React from 'react'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid from './SlideBarGrid'

export default () => (
  <>
    <Box width={'100%'} m={'auto'}>
      <FrobotDetailsContainer />
      <BattlesTable />
    </Box>
    <Box sx={{ position: 'relative', height: '100%' }}>
      <Box sx={{ position: 'fixed', top: 150, left: 4, zIndex: 999 }}>
        <SlideBarGrid />
      </Box>
    </Box>
  </>
)

