import { Box, Card, Grid, Typography } from '@mui/material'
import React from 'react'
import Button from '../../components/generic/Button/Button'

export default () => (
  <Grid container spacing={2}>
    <Grid item xs={12} sm={4}>
      <Box>
        <Box position={'relative'}>
          <Box
            component={'img'}
            src={'/images/frobot_bg.png'}
            width="100%"
            height="100%"
          ></Box>
          <Box
            sx={{
              position: 'absolute',
              top: '50%',
              left: '50%',
              p: 5,
              transform: 'translate(-50%, -50%)',
            }}
            component={'img'}
            width={'100%'}
            src={'/images/frobot1.png'}
          ></Box>
        </Box>
        
      </Box>
    </Grid>
    <Grid item xs={12} sm={4}>
      <Box p={3}>
        <Card
          sx={{ backgroundColor: '#212B36', color: '#fff', borderRadius: 4 }}
        >
          <Box p={2}>
            <h3>Card 2</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
          </Box>
        </Card>
      </Box>
    </Grid>
    <Grid item xs={12} sm={4}>
      <Box p={3}>
        <Card
          sx={{ backgroundColor: '#212B36', color: '#fff', borderRadius: 4 }}
        >
          <Box p={2}>
            <h3>Card 3</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
          </Box>
        </Card>
      </Box>
    </Grid>
  </Grid>
)

