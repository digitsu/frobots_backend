import React from 'react'
import { Box, Button, Grid, Typography } from '@mui/material'
import UnoccupiedSlot from '../../../../components/CreateMatch/UnoccupiedSlot'
export default ({ currentStep, setCurrentStep, slotDetails }) => {
  return (
    <>
      {currentStep === 1 && (
        <UnoccupiedSlot
          modifyHandler={() => setCurrentStep(0)}
          type={'closed'}
        />
      )}
    </>
  )
}
