import { Grid, Typography } from '@mui/material'
import React from 'react'

const sliderImages = [
  { id: 0, src: '/images/frobot_slider_1.png' },
  { id: 1, src: '/images/frobot_slider_2.png' },
  { id: 2, src: '/images/frobot_slider_3.png' },
  { id: 3, src: '/images/frobot_slider_4.png' },
  { id: 4, src: '/images/frobot_slider_5.png' },
  { id: 5, src: '/images/frobot_slider_6.png' },
  { id: 6, src: '/images/frobot_slider_7.png' },
]

export default () => {
  return (
    <Grid px={1} container spacing={2}>
      {sliderImages.map((image) => (
        <Grid item key={image.id} xs={12}>
          <img src={image.src} alt={`Image ${image.id}`} />
        </Grid>
      ))}
    </Grid>
  )
}
