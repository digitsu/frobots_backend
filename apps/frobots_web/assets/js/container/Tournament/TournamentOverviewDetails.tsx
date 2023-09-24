import { Box, Typography } from '@mui/material'
import React from 'react'
export default () => {
  return (
    <Box>
      <Typography variant="body1">
        Get ready for the most electrifying and adrenaline-pumping eSports
        championship of the future! "Frobot Fury" brings you the cutting-edge
        world of robotic warfare like never before. Witness the clash of steel,
        circuits, and strategy as elite robot engineers and gamers from around
        the world compete for supremacy in a high-stakes battle for glory.
      </Typography>
      <Box my={2}>
        <Box mb={1}>
          <Typography variant="subtitle1"> Prize Money:</Typography>
        </Box>
        <Box mb={1}>
          {' '}
          <Typography variant="body1"> 🥇 First Place:</Typography>
          <Typography variant="body2">
            The champion team will receive a jaw-dropping prize of 250,000 QDOS,
            along with the coveted "Frobot Fury Champion" title.
          </Typography>
        </Box>
        <Box mb={1}>
          {' '}
          <Typography variant="body1"> 🥈 Second Place: </Typography>
          <Typography variant="body2">
            The runners-up will not be left behind, taking home a substantial
            reward of 150,000 QDOS for their valiant efforts.
          </Typography>
        </Box>
        <Box mb={1}>
          <Typography variant="body1">🥉 Third Place:</Typography>
          <Typography variant="body2">
            The third-place team will be rewarded with a respectable prize of
            75,000 QDOS, proving that skill and determination always pay off.
          </Typography>
        </Box>
      </Box>
      <Box>
        <Box mb={1}>
          <Typography variant="subtitle1"> Entry Fee:</Typography>
        </Box>
        <Typography>10 QDOS</Typography>
      </Box>
    </Box>
  )
}
