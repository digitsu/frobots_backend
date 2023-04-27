import React, { useEffect } from 'react'
import { Box } from '@mui/material'
import { useDispatch } from 'react-redux'
import SlideBarGrid from '../FrobotDetails/SlideBarGrid'
import AttachedEquipments from './AttachedEquipments'
import AvailableEquipments from './AvailableEquipments'
import { frobotEquipmentActions } from '../../redux/slices/frobotEquipment'

export default (props: any) => {
  const dispatch = useDispatch()
  const {
    currentUser,
    frobotDetails,
    s3_base_url,
    frobotEquipments,
    userFrobots,
    equipmentInventory,
  } = props
  const { setCurrentEquipment, setActiveEquipmentKey } = frobotEquipmentActions
  const isOwnedFrobot = frobotDetails.user_id === currentUser.id
  const frobotId = frobotDetails.frobot_id

  useEffect(() => {
    const currentEquipment = equipmentInventory.length
      ? equipmentInventory[0]
      : frobotEquipments[0]
    dispatch(setCurrentEquipment(currentEquipment))
    dispatch(setActiveEquipmentKey(currentEquipment.equiment_key))
  })

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
          availableEquipments={equipmentInventory}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
        />

        <AttachedEquipments
          equipments={frobotEquipments}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
        />
      </Box>
    </Box>
  )
}
