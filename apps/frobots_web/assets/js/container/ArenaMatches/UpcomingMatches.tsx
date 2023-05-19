import React from 'react'
import { Box, Typography } from '@mui/material'
import { GridSlider } from '../../components/Slider'

export default ({ host_matches, joined_matches, watch_matches, imageList }) => {
  return (
    <Box>
      {joined_matches.length ? (
        <Box mt={4}>
          <Typography
            fontWeight={'bold'}
            variant="subtitle1"
            sx={{ p: 2, color: '#fff' }}
          >
            In Action
          </Typography>
          <GridSlider
            items={joined_matches}
            imageList={imageList}
            actionLabel={'Details'}
          />
        </Box>
      ) : (
        <></>
      )}

      {watch_matches.length ? (
        <Box mt={4}>
          <Typography
            fontWeight={'bold'}
            variant="subtitle1"
            sx={{ p: 2, color: '#fff' }}
          >
            As Spectator
          </Typography>
          <GridSlider
            items={watch_matches}
            imageList={imageList}
            actionLabel={'Details'}
          />
        </Box>
      ) : (
        <></>
      )}

      {host_matches.length ? (
        <Box mt={4}>
          <Typography
            fontWeight={'bold'}
            variant="subtitle1"
            sx={{ p: 2, color: '#fff' }}
          >
            As Organizer
          </Typography>
          <GridSlider
            items={host_matches}
            imageList={imageList}
            actionLabel={'Details'}
          />
        </Box>
      ) : (
        <></>
      )}
    </Box>
  )
}
