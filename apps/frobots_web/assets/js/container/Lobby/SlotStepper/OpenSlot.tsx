import React from 'react'
import UnoccupiedSlot from '../../../components/CreateMatch/UnoccupiedSlot'
export default ({ currentStep, setCurrentStep }) => {
  return (
    <>
      {currentStep === 1 && (
        <UnoccupiedSlot modifyHandler={() => setCurrentStep(0)} type={'open'} />
      )}
    </>
  )
}
