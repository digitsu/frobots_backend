import React, { useState } from 'react'
import SlotStepper from './SlotStepper'
import UnoccupiedSlot from '../../../components/CreateMatch/UnoccupiedSlot'
import OccupiedSlot from '../../../components/CreateMatch/OccupiedSlot'

export default ({ slotOptions, slotDetails, imageBaseUrl }) => {
  const [showOptions, setShowOptions] = useState(false)

  return (
    <>
      {showOptions ||
      slotDetails?.slotDetails === null ||
      slotDetails?.type === 'open' ? (
        <SlotStepper slotDetails={slotDetails} imageBaseUrl={imageBaseUrl} />
      ) : (
        <>
          {slotDetails?.type === 'closed' ? (
            <UnoccupiedSlot
              modifyHandler={() => setShowOptions(true)}
              type={slotDetails?.type}
            />
          ) : (
            <OccupiedSlot
              slotDetails={slotDetails?.slotDetails}
              modifyHandler={() => setShowOptions(true)}
              s3_base_url={imageBaseUrl}
            />
          )}
        </>
      )}
    </>
  )
}
