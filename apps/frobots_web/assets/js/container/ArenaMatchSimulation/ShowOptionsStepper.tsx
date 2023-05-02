import React, { useState } from 'react'
import UnoccupiedSlot from '../../components/CreateMatch/UnoccupiedSlot'
import OccupiedSlot from '../../components/CreateMatch/OccupiedSlot'
import { useSelector } from 'react-redux'
import SlotStepper from '../Lobby/SlotStepper'

export default ({ slotDetails, updateSlot, isHost }) => {
  const [showOptions, setShowOptions] = useState(false)
  const { frobot_user_id, current_user_id } = slotDetails
  const showModifyButton = isHost || frobot_user_id === current_user_id
  const { s3Url } = useSelector((store) => store.matchSimulation)
  return (
    <>
      {showOptions ? (
        <SlotStepper
          slotDetails={slotDetails}
          updateSlot={updateSlot}
          isHost={isHost}
          setShowOptions={setShowOptions}
        />
      ) : (
        <>
          {slotDetails?.slotDetails === null ||
          slotDetails?.type === 'open' ||
          slotDetails?.type === 'closed' ? (
            <UnoccupiedSlot
              modifyHandler={() => setShowOptions(true)}
              type={slotDetails?.type}
              showModifyButton={
                (slotDetails?.type === 'closed' && isHost) ||
                slotDetails?.type === 'open'
              }
            />
          ) : (
            <OccupiedSlot
              slotDetails={slotDetails?.slotDetails}
              modifyHandler={() => setShowOptions(true)}
              showModifyButton={showModifyButton}
              s3_base_url={s3Url}
            />
          )}
        </>
      )}
    </>
  )
}
