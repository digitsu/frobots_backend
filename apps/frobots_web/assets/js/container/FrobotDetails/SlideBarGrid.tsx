import { Box, Grid, styled } from '@mui/material'
import React, { useEffect, useState } from 'react'
import AddIcon from '@mui/icons-material/Add'

const PlusIcon = styled(AddIcon)({
  color: '#637381',
})

export interface UserFrobot {
  name: string
  avatar: string
  bio: string
  blockly_code: string
  brain_code: string
  class: string
  id: number
  inserted_at: Date
  pixellated_img: string
  user_id: number
  updated_at: Date
  xp: number
}

interface SlideBarGridProps {
  userFrobots: UserFrobot[]
  currentFrobot: any
  currentUser: any
}

export default (props: SlideBarGridProps) => {
  const [selectedImage, setSelectedImage] = useState(0)
  const { userFrobots, currentFrobot, currentUser } = props

  useEffect(() => {
    setSelectedImage(currentFrobot.frobot_id)
  }, [])

  const handleImageClick = (frobot: UserFrobot) => {
    setSelectedImage(frobot.id)
    window.location.href = `/garage/frobot?id=${frobot.id}`
  }

  const handleAddFrobot = () => {
    window.location.href = `/garage/create`
  }

  return (
    <>
      <Grid spacing={2} pl={2} pr={1}>
        {userFrobots.map((frobot) => (
          <Grid item key={frobot.id} xs={12} pb={3}>
            <Box
              component={'img'}
              src={frobot.pixellated_img}
              sx={{
                justifyContent: 'center',
                alignItems: 'center',
                borderRadius: '10px',
                width: 50,
                height: 50,
                border:
                  selectedImage === frobot.id ? '4px solid #00AB55' : 'none',
              }}
              onClick={() => handleImageClick(frobot)}
            ></Box>
          </Grid>
        ))}
        {currentUser.sparks && (
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              border: '1.5px solid #637381',
              borderRadius: '10px',
              width: 50,
              height: 50,
            }}
            onClick={handleAddFrobot}
          >
            <PlusIcon />
          </Box>
        )}
      </Grid>
    </>
  )
}
