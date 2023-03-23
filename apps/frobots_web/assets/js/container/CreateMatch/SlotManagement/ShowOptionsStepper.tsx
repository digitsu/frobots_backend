import React, { useState } from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import { useSelector } from 'react-redux'
import SlotStepper from './SlotStepper'
import UnoccupiedSlot from '../../../components/CreateMatch/UnoccupiedSlot'
import OccupiedSlot from '../../../components/CreateMatch/OccupiedSlot'

export default ({ slotOptions, slotDetails }) => {
  const [currentStep, setCurrentStep] = useState(0)
  const [showOptions, setShowOptions] = useState(false)
  const { userFrobots } = useSelector((store) => store.createMatch)
  return (
    <>
      {showOptions ? (
        <SlotStepper slotDetails={slotDetails} />
      ) : (
        <>
          {slotDetails?.slotDetails === null ||
          slotDetails?.type === 'open' ||
          slotDetails?.type === 'closed' ? (
            <UnoccupiedSlot
              modifyHandler={() => setShowOptions(true)}
              type={slotDetails?.type}
            />
          ) : (
            <OccupiedSlot
              slotDetails={slotDetails?.slotDetails}
              modifyHandler={() => setShowOptions(true)}
            />
          )}
        </>
      )}
    </>
  )
}
