import React, { useState } from 'react'
import { Box } from '@mui/material'
import AttachedEquipments from './AttachedEquipments'
import BattlesTable from './BattlesTable'
import FrobotDetailsContainer from './FrobotDetailsContainer'
import SlideBarGrid, { UserFrobot } from './SlideBarGrid'
import DetailsEdit from './DetailsEdit'

interface FrobotDetailsProps {
  avatars: any[]
  frobotDetails: any
  currentUser: any
  userFrobots: UserFrobot[]
  battles: any[]
  total_entries: number
  page: number
  page_size: number
  updateBattleSearch: any
  s3_base_url: string
  updateBasicDetails: any
}

export default (props: FrobotDetailsProps) => {
  const {
    avatars,
    frobotDetails,
    currentUser,
    userFrobots,
    s3_base_url,
    updateBasicDetails,
  } = props
  const isOwnedFrobot = frobotDetails.user_id === currentUser.id
  const frobotId = frobotDetails.frobot_id
  const [isEdit, enableEdit] = useState(false)

  const updateEditState = () => {
    enableEdit(!isEdit)
  }

  return (
    <Box mt={5}>
      <>
        {!isEdit && (
          <Box display={'flex'} sx={{ pl: isOwnedFrobot ? 0 : 4 }}>
            {isOwnedFrobot && (
              <SlideBarGrid
                userFrobots={userFrobots}
                currentFrobot={frobotDetails}
                currentUser={currentUser}
                imageBaseUrl={s3_base_url}
              />
            )}

            <Box
              width={'100%'}
              m={'auto'}
              pr={6}
              sx={{
                borderLeft: isOwnedFrobot ? '2px solid #2C333C' : 'none',
                paddingLeft: isOwnedFrobot ? 1.5 : 0,
              }}
            >
              <FrobotDetailsContainer
                frobotDetails={frobotDetails}
                currentUser={currentUser}
                isOwnedFrobot={isOwnedFrobot}
                imageBaseUrl={s3_base_url}
                xFrameDetails={
                  frobotDetails?.xframe_inst
                    ? frobotDetails?.xframe_inst[0]
                    : undefined
                }
                handleEditState={updateEditState}
              />

              {frobotDetails.class === 'U' && (
                <AttachedEquipments
                  equipments={[
                    ...frobotDetails.cannon_inst,
                    ...frobotDetails.scanner_inst,
                    ...frobotDetails.missile_inst,
                  ]}
                  isOwnedFrobot={isOwnedFrobot}
                  frobotId={frobotId}
                  imageBaseUrl={s3_base_url}
                />
              )}

              <BattlesTable {...props} />
            </Box>
          </Box>
        )}

        {isEdit && (
          <DetailsEdit
            frobot={frobotDetails}
            s3_base_url={s3_base_url}
            avatar_images={avatars}
            updateFrobotDetails={updateBasicDetails}
            handleEditState={updateEditState}
          />
        )}
      </>
    </Box>
  )
}
