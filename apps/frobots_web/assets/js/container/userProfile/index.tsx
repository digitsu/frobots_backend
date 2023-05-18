import React, { useState } from 'react'
import ProfileEdit from './ProfileEdit'
import ProfileView from './ProfileView'
import { Box } from '@mui/material'

interface UserProfileProps {
  name: string
  user: any
  s3_base_url: string
  user_avatars: string[]
  updateUserProfile: any
  updateUserEmail: any
  updateUserPassword: any
  editEnabled: boolean
}

export default (props: UserProfileProps) => {
  const { user, s3_base_url, user_avatars, editEnabled } = props
  const [isEdit, enableEdit] = useState(editEnabled || false)

  const updateEditState = () => {
    enableEdit(!isEdit)
  }

  return (
    <Box paddingBottom={3}>
      {!isEdit && (
        <ProfileView
          user={user}
          s3_base_url={s3_base_url}
          handleEditState={updateEditState}
        />
      )}

      {isEdit && (
        <ProfileEdit
          user={user}
          s3_base_url={s3_base_url}
          user_avatars={user_avatars}
          updateUserEmail={props.updateUserEmail}
          updateUserProfile={props.updateUserProfile}
          updateUserPassword={props.updateUserPassword}
          handleEditState={updateEditState}
        />
      )}
    </Box>
  )
}
