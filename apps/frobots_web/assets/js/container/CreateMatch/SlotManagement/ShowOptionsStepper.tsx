import React, { useState } from 'react'
import SlotStepper from './SlotStepper'
import UnoccupiedSlot from '../../../components/CreateMatch/UnoccupiedSlot'
import OccupiedSlot from '../../../components/CreateMatch/OccupiedSlot'

export default ({ slotOptions, slotDetails, imageBaseUrl }) => {
  const [showOptions, setShowOptions] = useState(false)

  return (
    <>
      {showOptions ? (
        <SlotStepper slotDetails={slotDetails} imageBaseUrl={imageBaseUrl} />
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
              imageBaseUrl={imageBaseUrl}
            />
          )}
        </>
      )}
    </>
  )
}
