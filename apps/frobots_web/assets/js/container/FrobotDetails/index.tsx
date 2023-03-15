import { Box } from '@mui/material'
import React from 'react'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'

export default () => (
  <Box width={'100%'} m={'auto'}>
    <FrobotDetailsContainer />
    <BattlesTable />
  </Box>
)

