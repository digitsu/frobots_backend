import React, { useState } from 'react'
import SlotStepper from './SlotStepper'
import UnoccupiedSlot from '../../components/CreateMatch/UnoccupiedSlot'
import OccupiedSlot from '../../components/CreateMatch/OccupiedSlot'
import { useSelector } from 'react-redux'

export default ({ slotDetails, updateSlot, isHost }) => {
  const [showOptions, setShowOptions] = useState(false)
  const { frobot_user_id, current_user_id } = slotDetails
  const showModifyButton = isHost || frobot_user_id === current_user_id
  const { s3Url, currentActiveSlot } = useSelector((store) => store.arenaLobby)
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
              showRemoveButton={frobot_user_id === current_user_id || isHost}
              showModifyButton={showModifyButton}
              clearFrobotHandler={() => {
                updateSlot({
                  type: 'open',
                  payload: {
                    slot_id: currentActiveSlot?.id,
                    status: 'open',
                    slot_type: null,
                    frobot_id: null,
                  },
                })
              }}
              s3_base_url={s3Url}
            />
          )}
        </>
      )}
    </>
  )
}
