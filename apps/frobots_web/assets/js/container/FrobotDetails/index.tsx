import React from 'react'
import { Box } from '@mui/material'
import AttachedEquipments from './AttachedEquipments'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid, { UserFrobot } from './SlideBarGrid'

interface FrobotDetailsProps {
  frobotDetails: any
  currentUser: any
  userFrobots: UserFrobot[]
  battles: any[]
  total_entries: number
  page: number
  page_size: number
  updateBattleSearch: any
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

            <AttachedEquipments
              equipments={[
                ...frobotDetails.cannon_inst,
                ...frobotDetails.scanner_inst,
                ...frobotDetails.missile_inst,
              ]}
              isOwnedFrobot={isOwnedFrobot}
            />

            <BattlesTable {...props} />
          </Box>
        </Box>
      </>
    </Box>
  )
}
