import React from 'react'
import { Box, Grid, Typography, Button } from '@mui/material'
import { useSelector } from 'react-redux'
import Card from '../../components/generic/Card'

export default ({ createFrobot, s3BaseUrl }) => {
  const { starterMech, frobotName, bio, brainCode, blocklyCode } = useSelector(
    (store: any) => store.createFrobot
  )
  const createFrobotHandler = () => {
    createFrobot({
      name: frobotName,
      bio,
      brain_code: brainCode?.brain_code,
      blockly_code: blocklyCode,
      avatar: starterMech?.avatar || '',
      pixellated_img: starterMech?.pixellated_img || '',
    })
  }

  return (
    <Box width={'60%'} m={'auto'} mt={10}>
      <Card>
        <Grid container>
          <Grid item lg={6}>
            <Box position={'relative'} width={'100%'} m={'auto'}>
              <Box
                component={'img'}
                width={'100%'}
                src={'/images/frobot_bg.png'}
              ></Box>
              <Box
                sx={{
                  transform: 'translate(-50%, -50%)',
                  objectFit: 'cover',
                }}
                top={'50%'}
                left={'50%'}
                zIndex={1}
                position={'absolute'}
                width={'100%'}
                height={'100%'}
                component={'img'}
                src={`${s3BaseUrl}${starterMech.avatar}`}
              />
            </Box>
          </Grid>
          <Grid item lg={6}>
            <Box px={8} py={4}>
              <Box mb={4}>
                {' '}
                <Typography mb={1}>Name</Typography>
                <Typography variant="h6">{frobotName}</Typography>
              </Box>
              <Box mb={4}>
                <Typography mb={1}>Bio</Typography>
                <Box sx={{ height: 208, overflowY: 'scroll' }}>
                  <Typography variant="caption">{bio}</Typography>
                </Box>
              </Box>
            </Box>
          </Grid>
        </Grid>
      </Card>
      <Box mt={6} mb={10}>
        <Button
          variant="contained"
          fullWidth
          sx={{ py: 1.5, mb: 10 }}
          onClick={createFrobotHandler}
        >
          Build Now
        </Button>
      </Box>
    </Box>
  )
}
