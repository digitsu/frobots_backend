import { Box, Button, Grid, styled } from '@mui/material'
import React, { useEffect, useState } from 'react'
import AddIcon from '@mui/icons-material/Add'

const StyledImg = styled('img')({
  maxWidth: '100%',
  height: 'auto',
})


const PlusIcon = styled(AddIcon)({
  color: '#637381',
})

const sliderImages = [
  { id: '1', src: '/images/frobot_slider_1.png' },
  // { id: '2', src: '/images/frobot_slider_2.png' },
  { id: '3', src: '/images/frobot_slider_3.png' },
  { id: '4', src: '/images/frobot_slider_4.png' },
  { id: '5', src: '/images/frobot_slider_5.png' },
  { id: '6', src: '/images/frobot_slider_6.png' },
  { id: '7', src: '/images/frobot_slider_7.png' },
]

interface SlideBarGridProps {
  isOwnedFrobot: boolean
}

export default (props: SlideBarGridProps) => {
  const [selectedImage, setSelectedImage] = useState('')
  const { isOwnedFrobot } = props

  useEffect(() => {
    if (
      location.search.split('?id=')[1] == 'undefined' ||
      location.search.split('?id=')[1] == '' ||
      location.search.split('?id=')[1] == undefined
    ) {
      setSelectedImage('1')
    } else {
      setSelectedImage(location.search.split('?id=')[1])
    }
  }, [])

  const handleImageClick = (image) => {
    setSelectedImage(image.id)
    window.location.href = `/garage/frobot?id=${image.id}`
  }

  const handleAddFrobot = () => {
    window.location.href = `/garage/create`
  }

  return (
    <>
      {isOwnedFrobot && (
        <Grid spacing={2} pl={2} pr={1} pt={8}>
          {sliderImages.map((image) => (
            <Grid item key={image.id} xs={12} pb={3}>
              <Box
                sx={{
                  border:
                    selectedImage === image.id ? '4px solid #00AB55' : 'none',
                }}
                onClick={() => handleImageClick(image)}
              >
                <StyledImg src={image.src} alt={`Image ${image.id}`} />
              </Box>
            </Grid>
          ))}
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
        </Grid>
      )}
    </>
  )
}
