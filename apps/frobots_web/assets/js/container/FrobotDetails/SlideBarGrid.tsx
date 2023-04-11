import { Box, Card, Grid, styled } from '@mui/material'
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
      <Grid pl={2} pr={1} pt={1}>
        {userFrobots.map((frobot) => (
          <Grid item key={frobot.id} xs={12} pb={3}>
            <Card
              sx={{
                bgcolor: '#212B36',
                borderRadius: '10px',
                paddingTop: '100%',
                position: 'relative',
                border:
                  selectedImage === frobot.id
                    ? '3px solid #00AB55'
                    : '3px solid #161c24',
              }}
              onClick={() => handleImageClick(frobot)}
            >
              <Box
                component={'img'}
                src={'/images/frobot_bg.png'}
                width="100%"
                height="100%"
                sx={{
                  position: 'absolute',
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                }}
              />
              <Box
                sx={{
                  position: 'absolute',
                  top: '50%',
                  left: '50%',
                  p: '2px',
                  transform: 'translate(-50%, -50%)',
                }}
                component={'img'}
                width={'100%'}
                src={frobot.avatar}
              />
            </Card>
          </Grid>
        ))}
        {currentUser.sparks && (
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              border: '3px solid #637381',
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
