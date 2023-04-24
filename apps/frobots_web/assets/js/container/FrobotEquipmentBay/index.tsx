import React from 'react'
import { Box } from '@mui/material'
import SlideBarGrid from '../FrobotDetails/SlideBarGrid'
import AttachedEquipments from './AttachedEquipments'
import AvailableEquipments from './AvailableEquipments'

export default (props: any) => {
  const {
    frobotDetails,
    currentUser,
    s3_base_url,
    availableEquipments,
    userFrobots,
  } = props
  const isOwnedFrobot = frobotDetails.user_id === currentUser.id
  const frobotId = frobotDetails.frobot_id

  return (
    <Box display={'flex'} width={'100%'} sx={{ pb: 2, pr: 5 }}>
      <SlideBarGrid
        imageBaseUrl={s3_base_url}
        userFrobots={userFrobots}
        currentFrobot={frobotDetails}
        currentUser={currentUser}
      />
      <Box
        width={'100%'}
        height={'100%'}
        m={'auto'}
        sx={{
          paddingRight: 0,
          borderLeft: isOwnedFrobot ? '2px solid #2C333C' : 'none',
          paddingLeft: isOwnedFrobot ? 2 : 0,
        }}
      >
        <AvailableEquipments
          availableEquipments={[
            ...availableEquipments.cannons,
            ...availableEquipments.missiles,
            ...availableEquipments.scanners,
            ...availableEquipments.xframes,
          ]}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
        />

        <AttachedEquipments
          equipments={[
            ...frobotDetails.xframe_inst,
            ...frobotDetails.cannon_inst,
            ...frobotDetails.scanner_inst,
            ...frobotDetails.missile_inst,
          ]}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
        />
      </Box>
    </Box>
  )
}
