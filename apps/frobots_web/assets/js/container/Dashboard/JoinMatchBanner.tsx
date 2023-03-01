import { Box, Typography } from '@mui/material'
import React from 'react'
import Button from '../../components/generic/Button/Button'
export default () => {
  return (
    <Box>
      <Box width={'90%'} m={'auto'} p={2}>
        <Typography>News & Updates</Typography>
      </Box>

      <Box sx={{ backgroundColor: '#000' }}>
        <Box width={'90%'} m={'auto'} p={3}>
          <Box
            display={'flex'}
            width={'100%'}
            justifyContent={'space-between'}
            alignItems={'flex-start'}
            mt={6}
          >
            <Box
              display={'flex'}
              flexDirection={'column'}
              justifyContent={'space-around'}
              alignSelf={'stretch'}
            >
              <Box>
                <Box mb={2}>
                  <Typography variant="h5">FROBOT WARS</Typography>
                </Box>
                <Typography variant="body2" color={'lightslategray'}>
                  Coming soon to world blockchain conference. Click to join
                  match
                </Typography>
              </Box>
              <Box>
                <Button
                  variant="contained"
                  sx={{ textTransform: 'capitalize', px: 5, py: 1 }}
                >
                  Join Match
                </Button>
              </Box>
            </Box>
            <Box>
              <Box
                component={'img'}
                src={'/images/frobot_purple.png'}
                width={312}
                height={320}
              />
            </Box>
          </Box>
        </Box>
      </Box>
    </Box>
  )
}
