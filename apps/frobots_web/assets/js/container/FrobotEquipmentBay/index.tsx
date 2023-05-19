import React, { useCallback, useEffect, useState } from 'react'
import { Box } from '@mui/material'
import { useDispatch } from 'react-redux'
import SideBarGrid from '../../components/Frobots/SideBar'
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
    detachEquipment,
    attachEquipment,
    redeployEquipment,
  } = props
  const { setCurrentEquipment, setActiveEquipmentKey } = frobotEquipmentActions
  const isOwnedFrobot = frobotDetails.user_id === currentUser.id
  const frobotId = frobotDetails.frobot_id
  const [attachedEquipments, setAttachedEquipments] = useState(frobotEquipments)
  const [availableEquipments, setAvailableEquipments] =
    useState(equipmentInventory)

  useEffect(() => {
    const currentEquipment = equipmentInventory.length
      ? equipmentInventory[0]
      : frobotEquipments[0]

    dispatch(setCurrentEquipment(currentEquipment))
    dispatch(setActiveEquipmentKey(currentEquipment.equipment_key))
    setAttachedEquipments(frobotEquipments)
    setAvailableEquipments(equipmentInventory)
  }, [])

  const handleEquipments = useCallback((e: any) => {
    let currentEquipment: any

    if (e?.detail?.currentEquipmentKey) {
      currentEquipment = [
        ...e.detail.equipmentInventory,
        ...e.detail.frobotEquipments,
      ].find(
        (equipment: any) =>
          equipment.equipment_key === e.detail.currentEquipmentKey
      )
    } else {
      currentEquipment = e.detail.equipmentInventory.length
        ? e.detail.equipmentInventory[0]
        : e.detail.frobotEquipments[0]
    }

    dispatch(setCurrentEquipment(currentEquipment))
    dispatch(setActiveEquipmentKey(currentEquipment.equipment_key))
    setAttachedEquipments(e.detail.frobotEquipments)
    setAvailableEquipments(e.detail.equipmentInventory)
  }, [])

  useEffect(() => {
    window.addEventListener(`phx:frobot_equipments_updated`, handleEquipments)

    return () =>
      document.removeEventListener(
        `phx:frobot_equipments_updated`,
        handleEquipments
      )
  }, [])

  return (
    <Box display={'flex'} width={'100%'} sx={{ pb: 2, pr: 5 }}>
      <SideBarGrid
        imageBaseUrl={s3_base_url}
        userFrobots={userFrobots}
        currentFrobot={frobotDetails}
        currentUser={currentUser}
        redirectBaseUrl="/garage/frobot/equipment_bay"
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
          availableEquipments={availableEquipments}
          equipmentsCount={availableEquipments.length}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
          attachEquipment={attachEquipment}
          detachEquipment={detachEquipment}
          redeployEquipment={redeployEquipment}
        />

        <AttachedEquipments
          equipments={attachedEquipments}
          equipmentsCount={attachedEquipments.length}
          isOwnedFrobot={isOwnedFrobot}
          frobotId={frobotId}
          imageBaseUrl={s3_base_url}
          detachEquipment={detachEquipment}
        />
      </Box>
    </Box>
  )
}
